['pragma solidity ^0.5.8;\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://eips.ethereum.org/EIPS/eip-20\n', ' */\n', 'interface IERC20 {\n', '    function transfer(address to, uint256 value) external returns (bool);\n', '\n', '    function approve(address spender, uint256 value) external returns (bool);\n', '\n', '    function transferFrom(address from, address to, uint256 value) external returns (bool);\n', '\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    function balanceOf(address who) external view returns (uint256);\n', '\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'library IterableMap {\n', '    \n', '    struct IMap {\n', '        mapping(address => uint256) mapToData;\n', '        mapping(address => uint256) mapToIndex; // start with index 1\n', '        address[] indexes;\n', '    }\n', '    \n', '    function insert(IMap storage self, address _address, uint256 _value) internal returns (bool replaced) {\n', '      \n', '        require(_address != address(0));\n', '        \n', '        if(self.mapToIndex[_address] == 0){\n', '            \n', '            // add new\n', '            self.indexes.push(_address);\n', '            self.mapToIndex[_address] = self.indexes.length;\n', '            self.mapToData[_address] = _value;\n', '            return false;\n', '        }\n', '        \n', '        // replace\n', '        self.mapToData[_address] = _value;\n', '        return true;\n', '    }\n', '    \n', '    function remove(IMap storage self, address _address) internal returns (bool success) {\n', '       \n', '        require(_address != address(0));\n', '        \n', '        // not existing\n', '        if(self.mapToIndex[_address] == 0){\n', '            return false;   \n', '        }\n', '        \n', '        uint256 deleteIndex = self.mapToIndex[_address];\n', '        if(deleteIndex <= 0 || deleteIndex > self.indexes.length){\n', '            return false;\n', '        }\n', '       \n', '         // if index to be deleted is not the last index, swap position.\n', '        if (deleteIndex < self.indexes.length) {\n', '            // swap \n', '            self.indexes[deleteIndex-1] = self.indexes[self.indexes.length-1];\n', '            self.mapToIndex[self.indexes[deleteIndex-1]] = deleteIndex;\n', '        }\n', '        self.indexes.length -= 1;\n', '        delete self.mapToData[_address];\n', '        delete self.mapToIndex[_address];\n', '       \n', '        return true;\n', '    }\n', '  \n', '    function contains(IMap storage self, address _address) internal view returns (bool exists) {\n', '        return self.mapToIndex[_address] > 0;\n', '    }\n', '      \n', '    function size(IMap storage self) internal view returns (uint256) {\n', '        return self.indexes.length;\n', '    }\n', '  \n', '    function get(IMap storage self, address _address) internal view returns (uint256) {\n', '        return self.mapToData[_address];\n', '    }\n', '\n', '    // start with index 0\n', '    function getKey(IMap storage self, uint256 _index) internal view returns (address) {\n', '        \n', '        if(_index < self.indexes.length){\n', '            return self.indexes[_index];\n', '        }\n', '        return address(0);\n', '    }\n', '}\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Unsigned math operations with safety checks that revert on error.\n', ' */\n', 'library SafeMath {\n', '    /**\n', '     * @dev Multiplies two unsigned integers, reverts on overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b);\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // Solidity only automatically asserts when dividing by 0\n', '        require(b > 0);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b <= a);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Adds two unsigned integers, reverts on overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a);\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),\n', '     * reverts when dividing by zero.\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b != 0);\n', '        return a % b;\n', '    }\n', '}\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '    address public owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '     * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '     * account.\n', '     */\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '     * @param newOwner The address to transfer ownership to.\n', '     */\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        require(newOwner != address(0));\n', '        emit OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', 'contract ZmineVoteBurn is Ownable {\n', '  \n', '    // Use itmap for all functions on the struct\n', '    using IterableMap for IterableMap.IMap;\n', '    using SafeMath for uint256;\n', '    \n', '    // ERC20 basic token contract being held\n', '    IERC20 public token;\n', '  \n', '    // map address => vote\n', '    IterableMap.IMap voteRecordMap;\n', '    // map address => token available for reclaim\n', '    IterableMap.IMap reclaimTokenMap;\n', '    \n', '    // time to start vote period\n', '    uint256 public timestampStartVote;\n', '    // time to end vote period\n', '    uint256 public timestampEndVote;\n', '    // time to enable reclaim token process\n', '    uint256 public timestampReleaseToken;\n', '    \n', '    // cumulative count for total vote\n', '    uint256 _totalVote;\n', '    \n', '    constructor(IERC20 _token) public {\n', '\n', '        token = _token;\n', '        \n', '        // (Mainnet) May 22, 2019 GMT (epoch time 1558483200)\n', '        // (Kovan) from now\n', '        timestampStartVote = 1558483200; \n', '        \n', '        // (Mainnet) May 28, 2019 GMT (epoch time 1559001600)\n', '        // (Kovan) period for 10 years\n', '        timestampEndVote = 1559001600; \n', '        \n', '        // (Mainnet) May 30, 2019 GMT (epoch time 1559174400)\n', '        // (Kovan) from now\n', '        timestampReleaseToken = 1559174400; \n', '    }\n', '    \n', '    /**\n', '     * modifier\n', '     */\n', '     \n', '    // during the votable period?\n', '    modifier onlyVotable() {\n', '        require(isVotable());\n', '        _;\n', '    }\n', '    \n', '    // during the reclaimable period?\n', '    modifier onlyReclaimable() {\n', '        require(isReclaimable());\n', '        _;\n', '    }\n', '  \n', '    /**\n', '     * public methods\n', '     */\n', '     \n', '    function isVotable() public view returns (bool){\n', '        return (timestampStartVote <= block.timestamp && block.timestamp <= timestampEndVote);\n', '    }\n', '    \n', '    function isReclaimable() public view returns (bool){\n', '        return (block.timestamp >= timestampReleaseToken);\n', '    }\n', '    \n', '    function countVoteUser() public view returns (uint256){\n', '        return voteRecordMap.size();\n', '    }\n', '    \n', '    function countVoteScore() public view returns (uint256){\n', '        return _totalVote;\n', '    }\n', '    \n', '    function getVoteByAddress(address _address) public view returns (uint256){\n', '        return voteRecordMap.get(_address);\n', '    }\n', '    \n', '    // vote by transfer token into this contract as collateral\n', '    // This process require approval from sender, to allow contract transfer token on the sender behalf.\n', '    function voteBurn(uint256 amount) public onlyVotable {\n', '\n', '        require(token.balanceOf(msg.sender) >= amount);\n', '        \n', '        // transfer token on the sender behalf.\n', '        token.transferFrom(msg.sender, address(this), amount);\n', '        \n', '        // calculate cumulative vote\n', '        uint256 newAmount = voteRecordMap.get(msg.sender).add(amount);\n', '        \n', '        // save to map\n', '        reclaimTokenMap.insert(msg.sender, newAmount);\n', '        voteRecordMap.insert(msg.sender, newAmount);\n', '        \n', '        // cumulative count total vote\n', '        _totalVote = _totalVote.add(amount);\n', '    }\n', '    \n', '    // Take the token back to the sender after reclaimable period has come.\n', '    function reclaimToken() public onlyReclaimable {\n', '      \n', '        uint256 amount = reclaimTokenMap.get(msg.sender);\n', '        require(amount > 0);\n', '        require(token.balanceOf(address(this)) >= amount);\n', '          \n', '        // transfer token back to sender\n', '        token.transfer(msg.sender, amount);\n', '        \n', '        // remove from map\n', '        reclaimTokenMap.remove(msg.sender);\n', '    }\n', '    \n', '    /**\n', '     * admin methods\n', '     */\n', '     \n', '    function adminCountReclaimableUser() public view onlyOwner returns (uint256){\n', '        return reclaimTokenMap.size();\n', '    }\n', '    \n', '    function adminCheckReclaimableAddress(uint256 index) public view onlyOwner returns (address){\n', '        \n', '        require(index >= 0); \n', '        \n', '        if(reclaimTokenMap.size() > index){\n', '            return reclaimTokenMap.getKey(index);\n', '        }else{\n', '            return address(0);\n', '        }\n', '    }\n', '    \n', '    function adminCheckReclaimableToken(uint256 index) public view onlyOwner returns (uint256){\n', '    \n', '        require(index >= 0); \n', '    \n', '        if(reclaimTokenMap.size() > index){\n', '            return reclaimTokenMap.get(reclaimTokenMap.getKey(index));\n', '        }else{\n', '            return 0;\n', '        }\n', '    }\n', '    \n', '    function adminCheckVoteAddress(uint256 index) public view onlyOwner returns (address){\n', '        \n', '        require(index >= 0); \n', '        \n', '        if(voteRecordMap.size() > index){\n', '            return voteRecordMap.getKey(index);\n', '        }else{\n', '            return address(0);\n', '        }\n', '    }\n', '    \n', '    function adminCheckVoteToken(uint256 index) public view onlyOwner returns (uint256){\n', '    \n', '        require(index >= 0); \n', '    \n', '        if(voteRecordMap.size() > index){\n', '            return voteRecordMap.get(voteRecordMap.getKey(index));\n', '        }else{\n', '            return 0;\n', '        }\n', '    }\n', '    \n', '    // perform reclaim token by admin \n', '    function adminReclaimToken(address _address) public onlyOwner {\n', '      \n', '        uint256 amount = reclaimTokenMap.get(_address);\n', '        require(amount > 0);\n', '        require(token.balanceOf(address(this)) >= amount);\n', '          \n', '        token.transfer(_address, amount);\n', '        \n', '        // remove from map\n', '        reclaimTokenMap.remove(_address);\n', '    }\n', '    \n', '    // Prevent deposit tokens by accident to a contract with the transfer function? \n', '    // The transaction will succeed but this will not be recognized by the contract.\n', '    // After reclaim process was ended, admin will able to transfer the remain tokens to himself. \n', '    // And return the remain tokens to senders by manual process.\n', '    function adminSweepMistakeTransferToken() public onlyOwner {\n', '        \n', '        require(reclaimTokenMap.size() == 0);\n', '        require(token.balanceOf(address(this)) > 0);\n', '        token.transfer(owner, token.balanceOf(address(this)));\n', '    }\n', '}']