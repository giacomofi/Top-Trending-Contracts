['pragma solidity ^0.4.11;\n', '\n', 'contract Vault {\n', '    \n', '    event Deposit(address indexed depositor, uint amount);\n', '    event Withdrawal(address indexed to, uint amount);\n', '\n', '    mapping (address => uint) public deposits;\n', '    uint minDeposit;\n', '    bool Locked;\n', '    address Owner;\n', '    uint Date;\n', '\n', '    function initVault() isOpen payable {\n', '        Owner = msg.sender;\n', '        minDeposit = 0.1 ether;\n', '        Locked = false;\n', '    }\n', '\n', '    function() payable { deposit(); }\n', '\n', '    function MinimumDeposit() constant returns (uint) { return minDeposit; }\n', '    function ReleaseDate() constant returns (uint) { return Date; }\n', '    function WithdrawalEnabled() internal returns (bool) { return Date > 0 && Date <= now; }\n', '\n', '    function deposit() payable {\n', '        if (msg.value >= MinimumDeposit()) {\n', '            deposits[msg.sender] += msg.value;\n', '        }\n', '        Deposit(msg.sender, msg.value);\n', '    }\n', '\n', '    function withdraw(address to, uint amount) onlyOwner {\n', '        if (WithdrawalEnabled()) {\n', '            if (deposits[msg.sender] > 0 && amount <= deposits[msg.sender]) {\n', '                to.transfer(amount);\n', '                Withdrawal(to, amount);\n', '            }\n', '        }\n', '    }\n', '    \n', '    function SetReleaseDate(uint NewDate) { Date = NewDate; }\n', '    modifier onlyOwner { if (msg.sender == Owner) _; }\n', '    function lock() { Locked = true; }\n', '    modifier isOpen { if (!Locked) _; }\n', '    \n', '}']