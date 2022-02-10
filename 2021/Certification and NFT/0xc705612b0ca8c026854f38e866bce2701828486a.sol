['/**\n', ' *Submitted for verification at Etherscan.io on 2021-02-07\n', '*/\n', '\n', 'pragma solidity 0.5.12;\n', '\n', '/**\n', ' * @title SafeMath \n', ' * @dev Unsigned math operations with safety checks that revert on error.\n', ' */\n', 'library SafeMath {\n', '    /**\n', '     * @dev Multiplie two unsigned integers, revert on overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b);\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Integer division of two unsigned integers truncating the quotient, revert on division by zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // Solidity only automatically asserts when dividing by 0\n', '        require(b > 0);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Subtract two unsigned integers, revert on underflow (i.e. if subtrahend is greater than minuend).\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b <= a);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Add two unsigned integers, revert on overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a);\n', '\n', '        return c;\n', '    }\n', '}\n', '\n', '/*\n', ' * @dev Provides information about the current execution context, including the\n', ' * sender of the transaction and its data. While these are generally available\n', ' * via msg.sender and msg.data, they should not be accessed in such a direct\n', ' * manner, since when dealing with GSN meta-transactions the account sending and\n', ' * paying for execution may not be the actual sender (as far as an application\n', ' * is concerned).\n', ' *\n', ' * This contract is only required for intermediate, library-like contracts.\n', ' */\n', '\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev See https://eips.ethereum.org/EIPS/eip-20\n', ' */\n', 'interface IERC20 {\n', '    function transfer(address to, uint256 value) external returns (bool); \n', '\n', '    function approve(address spender, uint256 value) external returns (bool); \n', '\n', '    function transferFrom(address from, address to, uint256 value) external returns (bool); \n', '\n', '    function totalSupply() external view returns (uint256); \n', '\n', '    function balanceOf(address who) external view returns (uint256);\n', '\n', '    function allowance(address owner, address spender) external view returns (uint256); \n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value); \n', '\n', '    event Approval(address indexed owner, address indexed spender, uint256 value); \n', '}\n', '\n', '\n', '\n', '/**\n', ' * @dev Contract module which provides a basic access control mechanism, where\n', ' * there is an account (an owner) that can be granted exclusive access to\n', ' * specific functions.\n', ' *\n', ' * This module is used through inheritance. It will make available the modifier\n', ' * `onlyOwner`, which can be applied to your functions to restrict their use to\n', ' * the owner.\n', ' */\n', 'contract Ownable  {\n', '    address internal _owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    constructor() public {\n', '        _owner = msg.sender;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the address of the current owner.\n', '     */\n', '    function owner() public view returns (address) {\n', '        return _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(isOwner(), "Ownable: caller is not the owner");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns true if the caller is the current owner.\n', '     */\n', '    function isOwner() public view returns (bool) {\n', '        return msg.sender == _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n', '     * Can only be called by the current owner.\n', '     */\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        _transferOwnership(newOwner);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n', '     */\n', '    function _transferOwnership(address newOwner) internal {\n', '        require(newOwner != address(0), "Ownable: new owner is the zero address");\n', '        emit OwnershipTransferred(_owner, newOwner);\n', '        _owner = newOwner;\n', '    }\n', '}\n', '\n', 'contract PairFeeDistribution is Ownable{\n', '    using SafeMath for uint256;\n', '    \n', '    struct PairInfo {\n', '        uint256 totalfee;\n', '        uint256 unclaimedfee;\n', '        uint256 accpreshare;\n', '    }\n', ' \n', '    struct UserInfo {\n', '        uint256 claimedfee;\n', '        uint256 rewardDebt;\n', '    }\n', '\n', '    address public factoryContract;\n', '    address[] public pairs;\n', '    address[] public users;\n', '    mapping(address => PairInfo) public pairInfo;\n', '\n', '    mapping(address =>mapping(address => UserInfo)) public userInfo;\n', '    mapping(address => bool) public userStatus;\n', '    mapping(address => uint256) public userIndex;\n', '    uint256 public pairUpdateIdx;\n', '    mapping(address => uint256) public withdrawIdx;\n', '    event AddInvestors(address user, bool update);\n', '    event RemoveInvestors(address user);\n', '    event UpdateInvestorPairPerShare(uint256 times);\n', '    event Withdrawfee(address pair, address account, uint256 amount);\n', '    event SetFactory(address preFactory, address newFactory);\n', '\n', '    function setFactory(address _factoryContract) public onlyOwner returns(bool) {\n', '        require(_factoryContract != address(0) , "The _factoryContract address cannot be zero address");\n', '        require(_factoryContract != factoryContract , "Repeated _factoryContract address");\n', '        emit SetFactory(factoryContract, _factoryContract);\n', '        factoryContract = _factoryContract;\n', '        return true;\n', '    }\n', '\n', '    modifier olnyFactory() {\n', '        require(msg.sender == factoryContract, "Caller is not the factoryContract");\n', '        _;\n', '    }\n', '\n', '    function addpair(address pair) public olnyFactory {\n', '        pairs.push(pair);\n', '    }\n', '\n', '    function addInvestors(address user, bool update) public onlyOwner returns(uint256){\n', '        require(user != address(0), "Investor address cannot be zero address");\n', '        require(!userStatus[user],"The user already exist");\n', '        require(pairUpdateIdx == 0);\n', '        uint256 length = pairs.length;\n', '        if (update) {\n', '            updateInvestorPairPerShare(length);\n', '        }\n', '        for (uint256 i = 0; i < length; i++) {\n', '             userInfo[user][pairs[i]].rewardDebt = pairInfo[pairs[i]].accpreshare.div(10000);\n', '        }\n', '        userStatus[user] = true;\n', '        users.push(user);\n', '        userIndex[user] = users.length.sub(1);\n', '        emit AddInvestors(user, update);\n', '        return users.length;\n', '    }\n', '\n', '    function removeInvestors(address user) public onlyOwner returns (uint256){\n', '        require(userStatus[user],"The user doesn\'t exist");\n', '        userStatus[user] = false;\n', '        userIndex[users[users.length.sub(1)]] = userIndex[user];\n', '        users[userIndex[user]] = users[users.length.sub(1)];\n', '        users.length--;\n', '        emit RemoveInvestors(user);\n', '        return users.length;\n', '    }\n', '\n', '    function updateInvestorPairPerShare(uint256 number) public onlyOwner {\n', '        uint256 userLength = users.length;\n', '        uint256 pairLength = pairs.length;\n', '        uint256 processCount;\n', '        uint256 index = pairUpdateIdx;\n', '        processCount = pairLength.sub(pairUpdateIdx) <= number ? pairLength.sub(pairUpdateIdx) : number;\n', '        for (uint256 i = pairUpdateIdx; i < processCount.add(pairUpdateIdx); i++) {\n', '            uint256 amount = IERC20(pairs[i]).balanceOf(address(this)).sub(pairInfo[pairs[i]].unclaimedfee);\n', '            if (amount > 0) {\n', '                pairInfo[pairs[i]].unclaimedfee = pairInfo[pairs[i]].unclaimedfee.add(amount);\n', '                pairInfo[pairs[i]].totalfee = pairInfo[pairs[i]].totalfee.add(amount);\n', '                pairInfo[pairs[i]].accpreshare = pairInfo[pairs[i]].accpreshare.add(amount.mul(10000).div(userLength));\n', '            }\n', '            index += 1;\n', '            if (index == pairLength) {\n', '                index = 0;\n', '                break;\n', '            }  \n', '        }\n', '        pairUpdateIdx = index;\n', '        emit UpdateInvestorPairPerShare(processCount);\n', '    }\n', '    \n', '    function withdrawfee(address paird, address account) public {\n', '        require(userStatus[msg.sender],"The caller doesn\'t exist");\n', '        PairInfo storage pair = pairInfo[paird];\n', '        UserInfo storage user = userInfo[msg.sender][paird];\n', '        uint256 amount = pair.accpreshare.div(10000).sub(user.rewardDebt);\n', '        if (amount >0) {\n', '            IERC20(paird).transfer(account,amount);\n', '            pair.unclaimedfee = pair.unclaimedfee.sub(amount);\n', '            user.rewardDebt = pair.accpreshare.div(10000);\n', '            user.claimedfee = user.claimedfee.add(amount);\n', '        }\n', '        emit Withdrawfee(paird, account, amount);\n', '    }\n', '\n', '    function batchwithdrawfee(address account, uint256 number) public {\n', '        require(userStatus[msg.sender],"The caller doesn\'t exist");\n', '        uint256 pairLength = pairs.length;\n', '        uint256 index = withdrawIdx[account];\n', '        uint256 processCount = pairLength.sub(index) <= number ? pairLength.sub(index) : number;\n', '        for (uint256 i = withdrawIdx[account]; i < processCount.add(withdrawIdx[account]); i++) {\n', '            uint256 amount = pairInfo[pairs[i]].accpreshare.div(10000).sub(userInfo[msg.sender][pairs[i]].rewardDebt);\n', '            if (amount >0) {\n', '                IERC20(pairs[i]).transfer(account,amount);\n', '                pairInfo[pairs[i]].unclaimedfee = pairInfo[pairs[i]].unclaimedfee.sub(amount);\n', '                userInfo[msg.sender][pairs[i]].rewardDebt = pairInfo[pairs[i]].accpreshare.div(10000);\n', '                userInfo[msg.sender][pairs[i]].claimedfee = userInfo[msg.sender][pairs[i]].claimedfee.add(amount);\n', '                emit Withdrawfee(pairs[i], account, amount);\n', '            }\n', '            index += 1;\n', '            if (index == pairLength) {\n', '                index = 0;\n', '                break;\n', '            }\n', '        }\n', '        withdrawIdx[account] = index;\n', '    }\n', '\n', '    function getpendingfee(address account,  address paird) public view returns(uint256){\n', '        PairInfo storage pair = pairInfo[paird];\n', '        UserInfo storage user = userInfo[account][paird];\n', '        uint256 amount = pair.accpreshare.div(10000).sub(user.rewardDebt);\n', '        if (!userStatus[account]){\n', '            return 0;\n', '        }else{\n', '            return amount;\n', '        }\n', '        \n', '    }\n', '\n', '    function getpairlength() public view returns(uint256){\n', '        return pairs.length;\n', '    }\n', '         \n', '}']