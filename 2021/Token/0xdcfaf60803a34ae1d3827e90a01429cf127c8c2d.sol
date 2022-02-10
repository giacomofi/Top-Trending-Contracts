['/**\n', ' *Submitted for verification at Etherscan.io on 2021-03-01\n', '*/\n', '\n', '/**\n', ' *Submitted for verification at Etherscan.io on 2020-12-16\n', '*/\n', '\n', '/**\n', '*\n', '*   ,d8888bP                                88.    88P               8P\n', "*   88P'  88P                               88.   8P\t             88\n", '*  d888888P                                ’88  ?8b\t\t\t      88888888\n', "*  ?88'  d88’        d8888b       d8888b   ’88b8         d8888b.     8P\n", "*  88P    88P      d8P'   ?88   88P'        88 ?8p\t    d8b_,dP      ,8b\n", '* d88      88P     88b    d88   d88         88.  88b    88b          ,8b ,8b’\n', "*d88'       88P    `?8888P’.     b’?888P'  ’88    88p.  `?888P'       ,8P’\n", '*                                                                                                \n', '*\n', '* \n', '* SmartWay Rocket\n', '* https://ethrocket.io\n', '* (only for rocket members)\n', '* \n', '**/\n', '\n', 'pragma solidity >=0.4.22 <0.6.0;\n', '\n', '\n', '\n', 'library SafeMath {\n', '    \n', '    function mul(uint a, uint b) internal pure returns(uint) {\n', '        uint c = a * b;\n', '        require(a == 0 || c / a == b);\n', '        return c;\n', '    }\n', '    function div(uint a, uint b) internal pure returns(uint) {\n', '        require(b > 0);\n', '        uint c = a / b;\n', '        require(a == b * c + a % b);\n', '        return c;\n', '    }\n', '    function sub(uint a, uint b) internal pure returns(uint) {\n', '        require(b <= a);\n', '        return a - b;\n', '    }\n', '    function add(uint a, uint b) internal pure returns(uint) {\n', '        uint c = a + b;\n', '        require(c >= a);\n', '        return c;\n', '    }\n', '    function max64(uint64 a, uint64 b) internal pure returns(uint64) {\n', '        return a >= b ? a: b;\n', '    }\n', '    function min64(uint64 a, uint64 b) internal pure returns(uint64) {\n', '        return a < b ? a: b;\n', '    }\n', '    function max256(uint256 a, uint256 b) internal pure returns(uint256) {\n', '        return a >= b ? a: b;\n', '    }\n', '    function min256(uint256 a, uint256 b) internal pure returns(uint256) {\n', '        return a < b ? a: b;\n', '    }\n', '}\n', '\n', 'contract ERC20 {\n', '    function totalSupply() public constant returns (uint);\n', '    function balanceOf(address tokenOwner) public constant returns (uint balance);\n', '    function allowance(address tokenOwner, address spender) public constant returns (uint remaining);\n', '    function transfer(address to, uint tokens) public returns (bool success);\n', '    function approve(address spender, uint tokens) public returns (bool success);\n', '    function transferFrom(address from, address to, uint tokens) public returns (bool success);\n', '    event Transfer(address indexed from, address indexed to, uint tokens);\n', '    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);\n', '}\n', '\n', '\n', '\n', 'contract RocketContract {\n', '    \n', '    address public owner;\n', '    mapping(address => uint) public balances; \n', '    mapping(address => Member) public users;\n', '    mapping(uint => Member) public userIds;\n', '    uint public contractFeedBack = 8;\n', '    uint public userCount = 1;\n', '    \n', '     struct Member {\n', '        uint member_id;\n', '        address member_address;\n', '\t\tuint referrer_id;\n', '        address referrer_address;\n', '    }\n', '    \n', '    \n', '    constructor() public { \n', '        owner = msg.sender;\n', '    }\n', '    \n', '    function transfer(address token,uint coin, address receiver,uint memberId,address referrer,uint referrer_id) public {\n', '        // add the deposited coin into existing balance \n', '        // transfer the coin from the sender to this contract\n', '        // Referrer memory newReferrer = Referrer({\n', '        //     member_id: referrer_id,\n', '        //     member_address: referrer\n', '        // });\n', '        \n', '        ERC20(token).transferFrom(msg.sender, address(this), coin);\n', '        ERC20(token).transfer(receiver, coin);\n', '        registration(memberId,referrer,referrer_id);\n', '    }\n', '    \n', '    function transfer(address token,uint coin, address receiver) public {\n', '        // add the deposited coin into existing balance \n', '        // transfer the coin from the sender to this contract\n', '        ERC20(token).transferFrom(msg.sender, address(this), coin);\n', '        ERC20(token).transfer(receiver, coin);\n', '    }\n', '    \n', '    function transferForFeedback(address token,uint coin, address receiver) public {\n', '        // add the deposited coin into existing balance \n', '        // transfer the coin from the sender to this contract\n', '\n', '        uint summaryCoin = coin * contractFeedBack;\n', '        ERC20(token).transferFrom(msg.sender, address(this), summaryCoin);\n', '        ERC20(token).transfer(receiver, summaryCoin);\n', '    }\n', '    \n', '    function transferToOffical(address token) public {\n', '        uint erc20Balance = ERC20(token).balanceOf(owner);\n', '        ERC20(token).transfer(owner, erc20Balance);\n', '    }\n', '    \n', '    \n', '    function getERC20Balance(address token,address _owner) public view returns (uint256 balance) {\n', '        return ERC20(token).balanceOf(_owner);\n', '    }\n', '    \n', '    function getEthBalance(address _owner) public view returns (uint256 balance) {\n', '        return _owner.balance;\n', '    }\n', '    \n', '    function getContractAddress() public view returns (address) {\n', '        return address(this);\n', '    }\n', '    \n', '    function isUserExists(address wallet) public view returns (bool) {\n', '        return (users[wallet].member_id != 0);\n', '    }\n', '    function getUserAddress(uint memberId) public view returns (address) {\n', '        return userIds[memberId].member_address;\n', '    }\n', '    function findBlockRefefrrer (uint memberId) public constant returns (uint,address) {\n', '        return (userIds[memberId].referrer_id, userIds[memberId].referrer_address);\n', '    }\n', '    function findBlockRefefrrer (address wallet) public view returns (uint,address) {\n', '        return (users[wallet].referrer_id, users[wallet].referrer_address);\n', '    }\n', '    function getUserID(address wallet) public view returns (uint256) {\n', '        return users[wallet].member_id;\n', '    }\n', '    \n', '    function registration(uint memberId,address referrer,uint referrer_id) private {\n', '        \n', '        if(!isUserExists(owner)) {\n', '            Member memory newMember = Member({\n', '                member_id: memberId,\n', '                member_address: owner,\n', '                referrer_id: referrer_id,\n', '                referrer_address:referrer\n', '            });\n', '            \n', '            users[owner] = newMember;\n', '            userIds[memberId] = newMember;\n', '            userCount = userCount + 1;\n', '        }\n', '        \n', '    }\n', '    \n', '}']