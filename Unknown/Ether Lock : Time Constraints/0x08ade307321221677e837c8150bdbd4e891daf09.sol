['pragma solidity ^0.4.15;\n', '\n', 'contract Vault {\n', '    \n', '    event Deposit(address indexed depositor, uint amount);\n', '    event Withdrawal(address indexed to, uint amount);\n', '    event TransferOwnership(address indexed from, address indexed to);\n', '    \n', '    address Owner;\n', '    mapping (address => uint) public Deposits;\n', '    uint minDeposit;\n', '    bool Locked;\n', '    uint Date;\n', '\n', '    function initVault() isOpen payable {\n', '        Owner = msg.sender;\n', '        minDeposit = 0.5 ether;\n', '        Locked = false;\n', '        deposit();\n', '    }\n', '\n', '    function() payable { deposit(); }\n', '\n', '    function deposit() payable addresses {\n', '        if (msg.value > 0) {\n', '            if (msg.value >= MinimumDeposit()) Deposits[msg.sender] += msg.value;\n', '            Deposit(msg.sender, msg.value);\n', '        }\n', '    }\n', '\n', '    function withdraw(uint amount) payable onlyOwner { withdrawTo(msg.sender, amount); }\n', '    \n', '    function withdrawTo(address to, uint amount) onlyOwner {\n', '        if (WithdrawalEnabled()) {\n', '            uint max = Deposits[msg.sender];\n', '            if (max > 0 && amount <= max) {\n', '                Withdrawal(to, amount);\n', '                to.transfer(amount);\n', '            }\n', '        }\n', '    }\n', '\n', '    function transferOwnership(address to) onlyOwner { TransferOwnership(Owner, to); Owner = to; }\n', '    function MinimumDeposit() constant returns (uint) { return minDeposit; }\n', '    function ReleaseDate() constant returns (uint) { return Date; }\n', '    function WithdrawalEnabled() internal returns (bool) { return Date > 0 && Date <= now; }\n', '    function SetReleaseDate(uint NewDate) { Date = NewDate; }\n', '    function lock() { Locked = true; }\n', '    modifier onlyOwner { if (msg.sender == Owner) _; }\n', '    modifier isOpen { if (!Locked) _; }\n', '    modifier addresses {\n', '        uint size;\n', '        assembly { size := extcodesize(caller) }\n', '        if (size > 0) return;\n', '        _;\n', '    }\n', '}']