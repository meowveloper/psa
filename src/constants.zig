
pub const usage_string = 
    \\
    \\    usage: psa -m=<mode> -h=<your-hash>
    \\    Modes: dict (dictionary attack), brute (brute-force), audit (batch audit)
    \\    Example: psa -m=dict -h=5f4dcc3b5aa765d61d8327deb882cf99 -w=rockyou.txt
    \\
;


pub const dict_mode_string = "dict";
pub const brute_mode_string = "brute";
pub const audit_mode_string = "audit";



pub const lowers = "abcdefghijklmnopqrstuvwxyz";
pub const lowers_and_numbers = "abcdefghijklmnopqrstuvwxyz0123456789";
pub const lowers_numbers_and_uppers = "abcdefghijklmnopqrstuvwxyz0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
pub const lowers_numbers_uppers_specChars = "abcdefghijklmnopqrstuvwxyz0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ!@#$%^&*()-_=+";

