['/**\n', ' *Submitted for verification at Etherscan.io on 2021-02-15\n', '*/\n', '\n', '// SPDX-License-Identifier: UNLICENSED\n', 'pragma solidity ^0.6.12;\n', 'interface IERC20 {\n', '    function totalSupply() external view returns (uint256);\n', '    function balanceOf(address account) external view returns (uint256);\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'library SafeMath {\n', '   \n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '\n', '  \n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '  \n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '    \n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '\n', 'contract StakingPRY{\n', '    using SafeMath for uint256;\n', '    address public token;\n', '    address public owner;\n', '    bool public staking = true;\n', '    \n', '     uint256 public oneMonthTime = 2592000;\n', '  \n', ' \n', '    uint256 public timeforunstaking;\n', '\n', '    mapping(address => uint256) public users;\n', '    uint256 public totaltokenstaked;\n', '    \n', '    constructor(address _token) public{\n', '        token = _token;\n', '        owner = msg.sender;\n', '    }\n', '    \n', '    \n', '    function totalSupplyOfTokens() public view returns(uint256){\n', '        return IERC20(token).balanceOf(address(this));\n', '    }\n', '    \n', '    function readtimeleft() public view returns(uint256){\n', '        if(now > timeforunstaking){\n', '            return 0;\n', '        }else{\n', '           return timeforunstaking.sub(now);\n', '        }\n', '     \n', '    }\n', '    \n', '    function lockToken(uint256 _amount) isStakingOn() public{\n', "        require(_amount >= 1000e18,'you are inputting amount less than 1000 tokens');\n", "        require(_amount.add(users[msg.sender]) <= 100000e18,'single user cannot invest more than 300k PRY');\n", '        IERC20(token).transferFrom(msg.sender,address(this),_amount);\n', '        users[msg.sender] = users[msg.sender].add(_amount);\n', '        totaltokenstaked =  totaltokenstaked.add(_amount);\n', '    }    \n', '    \n', '    function unlockTokens() isStakingOff() public returns(uint256){\n', '        address useraddr = msg.sender;\n', '        require(users[useraddr] >= 0);\n', '        \n', '        if(now > timeforunstaking){\n', '        IERC20(token).transfer(msg.sender,users[useraddr].add(users[useraddr].mul(10).div(100)));\n', '        totaltokenstaked = totaltokenstaked.sub(users[useraddr]);\n', '        users[useraddr] = 0;\n', '        return 1;\n', '        }\n', '        if(timeforunstaking.sub(now) > 2*oneMonthTime){\n', ' \n', '        IERC20(token).transfer(msg.sender,users[useraddr]);\n', '        totaltokenstaked = totaltokenstaked.sub(users[useraddr]);\n', '        users[useraddr] = 0;\n', '        return 1;\n', '        }\n', '        if(timeforunstaking.sub(now) > oneMonthTime && timeforunstaking.sub(now) <= 2*oneMonthTime){\n', '        uint amount = users[useraddr].mul(10).mul(25).div(100).div(100);\n', '        IERC20(token).transfer(msg.sender,users[useraddr].add(amount));\n', '        totaltokenstaked = totaltokenstaked.sub(users[useraddr]);\n', '        users[useraddr] = 0;\n', '        return 1;\n', '        }\n', '        if(timeforunstaking.sub(now) <= oneMonthTime && timeforunstaking.sub(now) > 0){\n', '        uint amount = users[useraddr].mul(10).mul(50).div(100).div(100);\n', '        IERC20(token).transfer(msg.sender,users[useraddr].add(amount));\n', '        totaltokenstaked = totaltokenstaked.sub(users[useraddr]);\n', '        users[useraddr] = 0;\n', '        return 1;\n', '        }  \n', '    }\n', '    \n', '    function turnOnStaking() onlyOwner() public{\n', "        require(now > timeforunstaking,'the time of unstaking has not finished');\n", '        staking = true;\n', '        timeforunstaking = 0;\n', '    }\n', '    \n', '    function turnOffStaking() onlyOwner() public{\n', "        require(now > timeforunstaking,'the time of unstaking has not finished');\n", '        staking = false;\n', '        timeforunstaking = now.add(3*oneMonthTime);\n', '    }\n', '    \n', '    modifier isStakingOn(){\n', "        require(staking == true,'staking period is off');\n", '        _;\n', '    }\n', '        \n', '    modifier isStakingOff(){\n', "        require(staking == false,'staking period is on');\n", '        _;\n', '    }\n', '        \n', '    modifier onlyOwner(){\n', "      require(msg.sender == owner,'you are not admin');\n", '      _;\n', '    }\n', '    \n', '    function adminTokenTransfer() external onlyOwner{\n', "        require(totalSupplyOfTokens() > 0,'the contract has no pry tokens');\n", '        IERC20(token).transfer(msg.sender,IERC20(token).balanceOf(address(this)));\n', '    }\n', '}']