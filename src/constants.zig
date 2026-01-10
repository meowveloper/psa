
pub const usage_string = 
    \\
    \\  Password Strength Auditor (PSA) - High Performance Security Tool
    \\
    \\  Usage: psa -m=<mode> [options]
    \\
    \\  Modes:
    \\    dict    Dictionary attack against a single hash.
    \\            Requires: -h=<hash>, -w=<wordlist>
    \\
    \\    brute   Brute-force attack against a single hash.
    \\            Requires: -h=<hash> (interactive parameters)
    \\
    \\    audit   Batch audit mode for multiple hashes.
    \\            (Interactive parameters)
    \\
    \\  Options:
    \\    -m=<mode>      Select mode (dict, brute, audit)
    \\    -h=<hash>      Target MD5 hash in hex format
    \\    -w=<wordlist>  Path to the dictionary file
    \\
    \\  Examples:
    \\    psa -m=dict -h=5f4dcc3b5aa765d61d8327deb882cf99 -w=rockyou.txt
    \\    psa -m=brute -h=5f4dcc3b5aa765d61d8327deb882cf99
    \\    psa -m=audit
    \\
;


pub const dict_mode_string = "dict";
pub const brute_mode_string = "brute";
pub const audit_mode_string = "audit";



pub const lowers = "abcdefghijklmnopqrstuvwxyz";
pub const lowers_and_numbers = "abcdefghijklmnopqrstuvwxyz0123456789";
pub const lowers_numbers_and_uppers = "abcdefghijklmnopqrstuvwxyz0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
pub const lowers_numbers_uppers_specChars = "abcdefghijklmnopqrstuvwxyz0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ!@#$%^&*()-_=+";

