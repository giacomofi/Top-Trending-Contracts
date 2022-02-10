['pragma solidity ^0.4.17;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '    function add(uint256 a, uint256 b) internal constant returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '    \n', '    function sub(uint256 a, uint256 b) internal constant returns (uint256) {\n', '        // Result must be a positive or zero\n', '        assert(b <= a); \n', '        return a - b;\n', '    }\n', '    \n', '    function mul(uint256 a, uint256 b) internal constant returns (uint256) {\n', '        uint256 c = a * b;\n', '        assert(a == 0 || c / a == b);\n', '        // Result must be a positive or zero\n', '        if (0 < c) c = 0;   \n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal constant returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', '        // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '        return c;\n', '    }\n', '}\n', '\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '  // The Ownable constructor sets the original `owner` of the contract to the sender account.\n', '  function Ownable() {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  // Throws if called by any account other than the owner.\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '}\n', '\n', '/**\n', ' *  Main contract: \n', ' *  *) You can refund eth*3 only between "refundTime" and "ownerTime".\n', ' *  *) The creator can only get the contract balance after "ownerTime".  \n', ' *  *) IMPORTANT! If the contract balance is less (you eth*3) then you get only half of the balance.\n', ' *  *) For 3x refund you must pay a fee 0.1 Eth.\n', '*/\n', 'contract Multiple3x is Ownable{\n', '\n', '    using SafeMath for uint256;\n', '    mapping (address=>uint) public deposits;\n', '    uint public refundTime = 1507719600;     // GMT: 11 October 2017, 11:00\n', '    uint public ownerTime = (refundTime + 1 minutes);   // +1 minute\n', '    uint maxDeposit = 1 ether;  \n', '    uint minDeposit = 100 finney;   // 0.1 eth\n', '\n', '\n', '    function() payable {\n', '        deposit();\n', '    }\n', '    \n', '    function deposit() payable { \n', '        require(now < refundTime);\n', '        require(msg.value >= minDeposit);\n', '        \n', '        uint256 dep = deposits[msg.sender];\n', '        uint256 sumDep = msg.value.add(dep);\n', '\n', '        if (sumDep > maxDeposit){\n', '            msg.sender.send(sumDep.sub(maxDeposit)); // return of overpaid eth \n', '            deposits[msg.sender] = maxDeposit;\n', '        }\n', '        else{\n', '            deposits[msg.sender] = sumDep;\n', '        }\n', '    }\n', '    \n', '    function refund() payable { \n', '        require(now >= refundTime && now < ownerTime);\n', '        require(msg.value >= 100 finney);        // fee for refund\n', '        \n', '        uint256 dep = deposits[msg.sender];\n', '        uint256 depHalf = this.balance.div(2);\n', '        uint256 dep3x = dep.mul(3);\n', '        deposits[msg.sender] = 0;\n', '\n', '        if (this.balance > 0 && dep3x > 0){\n', '            if (dep3x > this.balance){\n', '                msg.sender.send(dep3x);     // refund 3x\n', '            }\n', '            else{\n', '                msg.sender.send(depHalf);   // refund half of balance\n', '            }\n', '        }\n', '    }\n', '    \n', '    function refundOwner() { \n', '        require(now >= ownerTime);\n', '        if(owner.send(this.balance)){\n', '            suicide(owner);\n', '        }\n', '    }\n', '}']
['pragma solidity ^0.4.17;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '    function add(uint256 a, uint256 b) internal constant returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '    \n', '    function sub(uint256 a, uint256 b) internal constant returns (uint256) {\n', '        // Result must be a positive or zero\n', '        assert(b <= a); \n', '        return a - b;\n', '    }\n', '    \n', '    function mul(uint256 a, uint256 b) internal constant returns (uint256) {\n', '        uint256 c = a * b;\n', '        assert(a == 0 || c / a == b);\n', '        // Result must be a positive or zero\n', '        if (0 < c) c = 0;   \n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal constant returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '        return c;\n', '    }\n', '}\n', '\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '  // The Ownable constructor sets the original `owner` of the contract to the sender account.\n', '  function Ownable() {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  // Throws if called by any account other than the owner.\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '}\n', '\n', '/**\n', ' *  Main contract: \n', ' *  *) You can refund eth*3 only between "refundTime" and "ownerTime".\n', ' *  *) The creator can only get the contract balance after "ownerTime".  \n', ' *  *) IMPORTANT! If the contract balance is less (you eth*3) then you get only half of the balance.\n', ' *  *) For 3x refund you must pay a fee 0.1 Eth.\n', '*/\n', 'contract Multiple3x is Ownable{\n', '\n', '    using SafeMath for uint256;\n', '    mapping (address=>uint) public deposits;\n', '    uint public refundTime = 1507719600;     // GMT: 11 October 2017, 11:00\n', '    uint public ownerTime = (refundTime + 1 minutes);   // +1 minute\n', '    uint maxDeposit = 1 ether;  \n', '    uint minDeposit = 100 finney;   // 0.1 eth\n', '\n', '\n', '    function() payable {\n', '        deposit();\n', '    }\n', '    \n', '    function deposit() payable { \n', '        require(now < refundTime);\n', '        require(msg.value >= minDeposit);\n', '        \n', '        uint256 dep = deposits[msg.sender];\n', '        uint256 sumDep = msg.value.add(dep);\n', '\n', '        if (sumDep > maxDeposit){\n', '            msg.sender.send(sumDep.sub(maxDeposit)); // return of overpaid eth \n', '            deposits[msg.sender] = maxDeposit;\n', '        }\n', '        else{\n', '            deposits[msg.sender] = sumDep;\n', '        }\n', '    }\n', '    \n', '    function refund() payable { \n', '        require(now >= refundTime && now < ownerTime);\n', '        require(msg.value >= 100 finney);        // fee for refund\n', '        \n', '        uint256 dep = deposits[msg.sender];\n', '        uint256 depHalf = this.balance.div(2);\n', '        uint256 dep3x = dep.mul(3);\n', '        deposits[msg.sender] = 0;\n', '\n', '        if (this.balance > 0 && dep3x > 0){\n', '            if (dep3x > this.balance){\n', '                msg.sender.send(dep3x);     // refund 3x\n', '            }\n', '            else{\n', '                msg.sender.send(depHalf);   // refund half of balance\n', '            }\n', '        }\n', '    }\n', '    \n', '    function refundOwner() { \n', '        require(now >= ownerTime);\n', '        if(owner.send(this.balance)){\n', '            suicide(owner);\n', '        }\n', '    }\n', '}']