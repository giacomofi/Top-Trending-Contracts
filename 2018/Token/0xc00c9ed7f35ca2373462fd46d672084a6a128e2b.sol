['pragma solidity ^0.4.24;\n', '\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        c = a * b;\n', '        require(c / a == b, "SafeMath mul failed");\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        return a / b;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b <= a, "SafeMath sub failed");\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        c = a + b;\n', '        require(c >= a, "SafeMath add failed");\n', '        return c;\n', '    }\n', '}\n', '\n', 'contract Ownable {\n', '    address public owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner, "You are not owner.");\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address _newOwner) public onlyOwner {\n', '        require(_newOwner != address(0), "Invalid address.");\n', '\n', '        owner = _newOwner;\n', '\n', '        emit OwnershipTransferred(owner, _newOwner);\n', '    }\n', '}\n', '\n', 'contract Foundation is Ownable {\n', '    using SafeMath for uint256;\n', '\n', '    string public name = "Fomo3D Foundation (Asia)";\n', '\n', '    mapping(address => uint256) public depositOf;\n', '\n', '    struct Member {\n', '        address who;\n', '        uint256 shares;\n', '    }\n', '    Member[] private members;\n', '\n', '    event Deposited(address indexed who, uint256 amount);\n', '    event Withdrawn(address indexed who, uint256 amount);\n', '\n', '    constructor() public {\n', '        members.push(Member(address(0), 0));\n', '\n', '        members.push(Member(0x05dEbE8428CAe653eBA92a8A887CCC73C7147bB8, 60));\n', '        members.push(Member(0xF53e5f0Af634490D33faf1133DE452cd9fF987e1, 20));\n', '        members.push(Member(0x34d26e1325352d7b3f91df22ae97894b0c5343b7, 20));\n', '    }\n', '\n', '    function() public payable {\n', '        deposit();\n', '    }\n', '\n', '    function deposit() public payable {\n', '        uint256 amount = msg.value;\n', '        require(amount > 0, "Deposit failed - zero deposits not allowed");\n', '\n', '        for (uint256 i = 1; i < members.length; i++) {\n', '            if (members[i].shares > 0) {\n', '                depositOf[members[i].who] = depositOf[members[i].who].add(amount.mul(members[i].shares).div(100));\n', '            }\n', '        }\n', '\n', '        emit Deposited(msg.sender, amount);\n', '    }\n', '\n', '    function withdraw(address _who) public {\n', '        uint256 amount = depositOf[_who];\n', '        require(amount > 0 && amount <= address(this).balance, "Insufficient amount.");\n', '\n', '        depositOf[_who] = depositOf[_who].sub(amount);\n', '\n', '        _who.transfer(amount);\n', '\n', '        emit Withdrawn(_who, amount);\n', '    }\n', '\n', '    function setMember(address _who, uint256 _shares) public onlyOwner {\n', '        uint256 memberIndex = 0;\n', '        uint256 sharesSupply = 100;\n', '        for (uint256 i = 1; i < members.length; i++) {\n', '            if (members[i].who == _who) {\n', '                memberIndex = i;\n', '            } else if (members[i].shares > 0) {\n', '                sharesSupply = sharesSupply.sub(members[i].shares);\n', '            }\n', '        }\n', '        require(_shares <= sharesSupply, "Insufficient shares.");\n', '\n', '        if (memberIndex > 0) {\n', '            members[memberIndex].shares = _shares;\n', '        } else {\n', '            members.push(Member(_who, _shares));\n', '        }\n', '    }\n', '}']