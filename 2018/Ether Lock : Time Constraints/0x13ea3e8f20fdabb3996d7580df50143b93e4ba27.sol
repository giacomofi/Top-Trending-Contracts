['pragma solidity ^0.4.0;\n', '\n', 'contract Dealer {\n', '\n', '    address public pitboss;\n', '    uint public constant ceiling = 0.25 ether;\n', '\n', '    event Deposit(address indexed _from, uint _value);\n', '\n', '    function Dealer() public {\n', '      pitboss = msg.sender;\n', '    }\n', '\n', '    function () public payable {\n', '      Deposit(msg.sender, msg.value);\n', '    }\n', '\n', '    modifier pitbossOnly {\n', '      require(msg.sender == pitboss);\n', '      _;\n', '    }\n', '\n', '    function cashout(address winner, uint amount) public pitbossOnly {\n', '      winner.transfer(amount);\n', '    }\n', '\n', '    function overflow() public pitbossOnly {\n', '      require (this.balance > ceiling);\n', '      pitboss.transfer(this.balance - ceiling);\n', '    }\n', '\n', '    function kill() public pitbossOnly {\n', '      selfdestruct(pitboss);\n', '    }\n', '\n', '}']
['pragma solidity ^0.4.0;\n', '\n', 'contract Dealer {\n', '\n', '    address public pitboss;\n', '    uint public constant ceiling = 0.25 ether;\n', '\n', '    event Deposit(address indexed _from, uint _value);\n', '\n', '    function Dealer() public {\n', '      pitboss = msg.sender;\n', '    }\n', '\n', '    function () public payable {\n', '      Deposit(msg.sender, msg.value);\n', '    }\n', '\n', '    modifier pitbossOnly {\n', '      require(msg.sender == pitboss);\n', '      _;\n', '    }\n', '\n', '    function cashout(address winner, uint amount) public pitbossOnly {\n', '      winner.transfer(amount);\n', '    }\n', '\n', '    function overflow() public pitbossOnly {\n', '      require (this.balance > ceiling);\n', '      pitboss.transfer(this.balance - ceiling);\n', '    }\n', '\n', '    function kill() public pitbossOnly {\n', '      selfdestruct(pitboss);\n', '    }\n', '\n', '}']