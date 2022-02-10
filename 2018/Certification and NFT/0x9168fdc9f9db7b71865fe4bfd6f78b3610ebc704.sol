['/*\n', '   Copyright (C) 2017  The Halo Platform by Scott Morrison\n', '                https://www.haloplatform.tech/\n', '\n', '   This is free software and you are welcome to redistribute it under certain\n', '   conditions. ABSOLUTELY NO WARRANTY; for details visit:\n', '   https://www.gnu.org/licenses/gpl-2.0.html\n', '*/\n', 'pragma solidity ^0.4.23;\n', '\n', 'contract Ownable {\n', '    address public Owner;\n', '    constructor() public { Owner = msg.sender; }\n', '    modifier onlyOwner() { if (Owner == msg.sender) { _; } }\n', '    \n', '    function transferOwner(address _owner) public onlyOwner {\n', '        address previousOwner;\n', '        if (address(this).balance == 0) {\n', '            previousOwner = Owner;\n', '            Owner = _owner;\n', '            emit NewOwner(previousOwner, Owner);\n', '        }\n', '    }\n', '    event NewOwner(address indexed oldOwner, address indexed newOwner);\n', '}\n', '\n', 'contract DepositCapsule is Ownable {\n', '    address public Owner;\n', '    mapping (address=>uint) public deposits;\n', '    uint public openDate;\n', '    uint public minimum;\n', '    \n', '    function initCapsule(uint openOnDate) public {\n', '        Owner = msg.sender;\n', '        openDate = openOnDate;\n', '        minimum = 0.5 ether;\n', '        emit Initialized(Owner, openOnDate);\n', '    }\n', '    event Initialized(address indexed owner, uint openOn);\n', '    \n', '    function() public payable {  }\n', '    \n', '    function deposit() public payable {\n', '        if (msg.value >= minimum) {\n', '            deposits[msg.sender] += msg.value;\n', '            emit Deposit(msg.sender, msg.value);\n', '        } else revert();\n', '    }\n', '    event Deposit(address indexed depositor, uint amount);\n', '\n', '    function withdraw(uint amount) public onlyOwner {\n', '        if (now >= openDate) {\n', '            uint max = deposits[msg.sender];\n', '            if (amount <= max && max > 0) {\n', '                if (msg.sender.send(amount))\n', '                    emit Withdrawal(msg.sender, amount);\n', '            }\n', '        }\n', '    }\n', '    event Withdrawal(address indexed withdrawer, uint amount);\n', '    \n', '    function kill() public onlyOwner {\n', '        if (address(this).balance >= 0)\n', '            selfdestruct(msg.sender);\n', '\t}\n', '}']
['/*\n', '   Copyright (C) 2017  The Halo Platform by Scott Morrison\n', '                https://www.haloplatform.tech/\n', '\n', '   This is free software and you are welcome to redistribute it under certain\n', '   conditions. ABSOLUTELY NO WARRANTY; for details visit:\n', '   https://www.gnu.org/licenses/gpl-2.0.html\n', '*/\n', 'pragma solidity ^0.4.23;\n', '\n', 'contract Ownable {\n', '    address public Owner;\n', '    constructor() public { Owner = msg.sender; }\n', '    modifier onlyOwner() { if (Owner == msg.sender) { _; } }\n', '    \n', '    function transferOwner(address _owner) public onlyOwner {\n', '        address previousOwner;\n', '        if (address(this).balance == 0) {\n', '            previousOwner = Owner;\n', '            Owner = _owner;\n', '            emit NewOwner(previousOwner, Owner);\n', '        }\n', '    }\n', '    event NewOwner(address indexed oldOwner, address indexed newOwner);\n', '}\n', '\n', 'contract DepositCapsule is Ownable {\n', '    address public Owner;\n', '    mapping (address=>uint) public deposits;\n', '    uint public openDate;\n', '    uint public minimum;\n', '    \n', '    function initCapsule(uint openOnDate) public {\n', '        Owner = msg.sender;\n', '        openDate = openOnDate;\n', '        minimum = 0.5 ether;\n', '        emit Initialized(Owner, openOnDate);\n', '    }\n', '    event Initialized(address indexed owner, uint openOn);\n', '    \n', '    function() public payable {  }\n', '    \n', '    function deposit() public payable {\n', '        if (msg.value >= minimum) {\n', '            deposits[msg.sender] += msg.value;\n', '            emit Deposit(msg.sender, msg.value);\n', '        } else revert();\n', '    }\n', '    event Deposit(address indexed depositor, uint amount);\n', '\n', '    function withdraw(uint amount) public onlyOwner {\n', '        if (now >= openDate) {\n', '            uint max = deposits[msg.sender];\n', '            if (amount <= max && max > 0) {\n', '                if (msg.sender.send(amount))\n', '                    emit Withdrawal(msg.sender, amount);\n', '            }\n', '        }\n', '    }\n', '    event Withdrawal(address indexed withdrawer, uint amount);\n', '    \n', '    function kill() public onlyOwner {\n', '        if (address(this).balance >= 0)\n', '            selfdestruct(msg.sender);\n', '\t}\n', '}']
