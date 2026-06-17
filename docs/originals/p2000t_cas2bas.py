import struct
import re
import sys

# Complete token map based on user requirements and manual Tabel 6
TOKEN_MAP = {
    128: "END", 129: "FOR", 130: "NEXT", 131: "DATA", 132: "INPUT", 133: "DIM",
    134: "READ", 135: "LET", 136: "GOTO", 137: "RUN", 138: "IF", 139: "RESTORE",
    140: "GOSUB", 141: "RETURN", 142: "REM", 143: "STOP", 144: "CONSOLE", 145: "WIDTH",
    146: "ELSE", 147: "TRON", 148: "TROFF", 149: "SWAP", 150: "ERASE", 151: "DEFSTR",
    152: "DEFINT", 153: "DEFSNG", 154: "DEFDBL", 155: "LINE", 156: "EDIT", 157: "ERROR",
    158: "RESUME", 159: "OUT", 160: "ON", 161: "WAIT", 162: "LPRINT", 163: "DEF",
    164: "POKE", 165: "PRINT", 166: "CONT", 167: "LIST", 168: "LLIST", 169: "DELETE",
    170: "AUTO", 171: "CLEAR", 172: "CLOAD", 173: "CSAVE", 174: "NEW", 175: "TAB(",
    176: "TO", 177: "FN", 178: "SPC(", 179: "USING", 180: "VARPTR", 181: "USR",
    182: "ERL", 183: "ERR", 184: "STRING", 185: "INSTR", 186: "THEN", 187: "NOT",
    188: "STEP", 189: "+", 190: "-", 191: "*", 192: "/", 193: "^", 194: "AND",
    195: "OR", 196: "XOR", 197: "EQV", 198: "IMP", 199: "MOD", 200: "DIV",
    201: ">", 202: "=", 203: "<", 204: "SGN", 205: "INT", 206: "ABS", 207: "FRE",
    208: "INP", 209: "LPOS", 210: "POS", 211: "SQR", 212: "RND", 213: "LOG",
    214: "EXP", 215: "COS", 216: "SIN", 217: "TAN", 218: "ATN", 219: "PEEK",
    220: "CINT", 221: "CSNG", 222: "CDBL", 223: "FIX", 225: "OCT$", 226: "HEX$",
    227: "STR$", 228: "VAL", 229: "ASC", 230: "CHR$", 231: "SPACE$", 232: "LEFT$",
    233: "RIGHT$", 234: "MID$"
}

def decode_cas_to_basic(input_file_path):
    header_size = 256
    data_size = 1024
    program_size = None
    binary_data = bytearray()

    # Step 1: Extract binary data using block logic
    with open(input_file_path, 'rb') as f:
        while True:
            block = f.read(header_size + data_size)
            if not block:
                break
            if not program_size:
                # Read program size from the specific CAS header offset
                program_size = int.from_bytes(block[0x34:0x36], byteorder='little')
            binary_data.extend(block[-data_size:])

    # Truncate to the actual program size
    basic_binary = binary_data[:program_size]
    print ("basic_binary size: %d" % len(basic_binary))

    # Step 2: Parse binary into BASIC source [cite: 152]
    decoded_lines = []
    i = 0
    # Line structure: [Pointer (2b)] [Line Number (2b)] [Content] [0x00] [cite: 152]
    while i < len(basic_binary) - 4:
        try:
            line_num = struct.unpack('<H', basic_binary[i+2:i+4])[0]
            if 0 <= line_num <= 65529:
                current_line = f"{line_num} "
                pos = i + 4
                while pos < len(basic_binary) and basic_binary[pos] != 0:
                    byte = basic_binary[pos]
                    if byte in TOKEN_MAP:
                        current_line += f"{TOKEN_MAP[byte]}"
                    elif 32 <= byte <= 126:
                        current_line += chr(byte)
                    else:
                        current_line += f"<{byte:02X}>"
                    pos += 1
                decoded_lines.append(current_line)
                i = pos + 1
            else:
                i += 1
        except:
            i += 1

    return "\n".join(decoded_lines)

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python decode.py <input_file.cas>")
    else:
        result = decode_cas_to_basic(sys.argv[1])
        output_file = sys.argv[1].replace('.cas', '_source.bas')
        with open(output_file, 'w', encoding='utf-8') as f:
            f.write(result)
        print(f"Successfully decoded to {output_file}")