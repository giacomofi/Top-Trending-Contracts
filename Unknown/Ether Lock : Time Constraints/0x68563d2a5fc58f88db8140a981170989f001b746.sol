['pragma solidity ^0.4.16;\n', '\n', 'contract Ownable {\n', '    address public Owner;\n', '    \n', '    function Ownable() { Owner = msg.sender; }\n', '\n', '    modifier onlyOwner() {\n', '        if( Owner == msg.sender ) {\n', '            _;\n', '        }\n', '    }\n', '    \n', '    function transferOwner(address _owner) onlyOwner {\n', '        if( this.balance == 0 ) {\n', '            Owner = _owner;\n', '        }\n', '    }\n', '}\n', '\n', 'contract TimeCapsuleEvent is Ownable {\n', '    address public Owner;\n', '    mapping (address=>uint) public deposits;\n', '    uint public openDate;\n', '    \n', '    event Initialized(address indexed owner, uint openOn);\n', '    function initCapsule(uint open) {\n', '        Owner = msg.sender;\n', '        openDate = open;\n', '        Initialized(Owner, openDate);\n', '    }\n', '\n', '    function() payable { deposit(); }\n', '\n', '    event Deposit(address indexed depositor, uint amount);\n', '    function deposit() payable {\n', '        if( msg.value >= 0.5 ether ) {\n', '            deposits[msg.sender] += msg.value;\n', '            Deposit(msg.sender, msg.value);\n', '        } else throw;\n', '    }\n', '\n', '    event Withdrawal(address indexed withdrawer, uint amount);\n', '    function withdraw(uint amount) payable onlyOwner {\n', '        if( now >= openDate ) {\n', '            uint max = deposits[msg.sender];\n', '            if( amount <= max && max > 0 ) {\n', '                msg.sender.send( amount );\n', '                Withdrawal(msg.sender, amount);\n', '            }\n', '        }\n', '    }\n', '\n', '    function kill() onlyOwner {\n', '        if( this.balance == 0 )\n', '            suicide( msg.sender );\n', '\t}\n', '}']
['pragma solidity ^0.4.16;\n', '\n', 'contract Ownable {\n', '    address public Owner;\n', '    \n', '    function Ownable() { Owner = msg.sender; }\n', '\n', '    modifier onlyOwner() {\n', '        if( Owner == msg.sender ) {\n', '            _;\n', '        }\n', '    }\n', '    \n', '    function transferOwner(address _owner) onlyOwner {\n', '        if( this.balance == 0 ) {\n', '            Owner = _owner;\n', '        }\n', '    }\n', '}\n', '\n', 'contract TimeCapsuleEvent is Ownable {\n', '    address public Owner;\n', '    mapping (address=>uint) public deposits;\n', '    uint public openDate;\n', '    \n', '    event Initialized(address indexed owner, uint openOn);\n', '    function initCapsule(uint open) {\n', '        Owner = msg.sender;\n', '        openDate = open;\n', '        Initialized(Owner, openDate);\n', '    }\n', '\n', '    function() payable { deposit(); }\n', '\n', '    event Deposit(address indexed depositor, uint amount);\n', '    function deposit() payable {\n', '        if( msg.value >= 0.5 ether ) {\n', '            deposits[msg.sender] += msg.value;\n', '            Deposit(msg.sender, msg.value);\n', '        } else throw;\n', '    }\n', '\n', '    event Withdrawal(address indexed withdrawer, uint amount);\n', '    function withdraw(uint amount) payable onlyOwner {\n', '        if( now >= openDate ) {\n', '            uint max = deposits[msg.sender];\n', '            if( amount <= max && max > 0 ) {\n', '                msg.sender.send( amount );\n', '                Withdrawal(msg.sender, amount);\n', '            }\n', '        }\n', '    }\n', '\n', '    function kill() onlyOwner {\n', '        if( this.balance == 0 )\n', '            suicide( msg.sender );\n', '\t}\n', '}']
