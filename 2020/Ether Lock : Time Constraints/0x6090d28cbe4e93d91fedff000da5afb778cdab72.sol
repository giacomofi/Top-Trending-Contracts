['//SPDX-License-Identifier: UNLICENSED\n', '\n', 'pragma solidity 0.6.12;\n', '\n', '//staking PWTStacking\n', '\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'library EnumerableSet {\n', '\n', '    struct Set {\n', '        bytes32[] _values;\n', '\n', '        mapping (bytes32 => uint256) _indexes;\n', '    }\n', '\n', '    function _add(Set storage set, bytes32 value) private returns (bool) {\n', '        if (!_contains(set, value)) {\n', '            set._values.push(value);\n', '\n', '            set._indexes[value] = set._values.length;\n', '            return true;\n', '        } else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '    function _remove(Set storage set, bytes32 value) private returns (bool) {\n', "        // We read and store the value's index to prevent multiple reads from the same storage slot\n", '        uint256 valueIndex = set._indexes[value];\n', '\n', '        if (valueIndex != 0) { // Equivalent to contains(set, value)\n', '        \n', '            uint256 toDeleteIndex = valueIndex - 1;\n', '            uint256 lastIndex = set._values.length - 1;\n', '\n', '\n', '            bytes32 lastvalue = set._values[lastIndex];\n', '\n', '            // Move the last value to the index where the value to delete is\n', '            set._values[toDeleteIndex] = lastvalue;\n', '            // Update the index for the moved value\n', '            set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based\n', '\n', '            // Delete the slot where the moved value was stored\n', '            set._values.pop();\n', '\n', '            // Delete the index for the deleted slot\n', '            delete set._indexes[value];\n', '\n', '            return true;\n', '        } else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '    /**\n', '     * @dev Returns true if the value is in the set. O(1).\n', '     */\n', '    function _contains(Set storage set, bytes32 value) private view returns (bool) {\n', '        return set._indexes[value] != 0;\n', '    }\n', '\n', '    function _length(Set storage set) private view returns (uint256) {\n', '        return set._values.length;\n', '    }\n', '\n', '    function _at(Set storage set, uint256 index) private view returns (bytes32) {\n', '        require(set._values.length > index, "EnumerableSet: index out of bounds");\n', '        return set._values[index];\n', '    }\n', '\n', '    // AddressSet\n', '\n', '    struct AddressSet {\n', '        Set _inner;\n', '    }\n', '\n', '    function add(AddressSet storage set, address value) internal returns (bool) {\n', '        return _add(set._inner, bytes32(uint256(value)));\n', '    }\n', '\n', '    function remove(AddressSet storage set, address value) internal returns (bool) {\n', '        return _remove(set._inner, bytes32(uint256(value)));\n', '    }\n', '\n', '    /**\n', '     * @dev Returns true if the value is in the set. O(1).\n', '     */\n', '    function contains(AddressSet storage set, address value) internal view returns (bool) {\n', '        return _contains(set._inner, bytes32(uint256(value)));\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the number of values in the set. O(1).\n', '     */\n', '    function length(AddressSet storage set) internal view returns (uint256) {\n', '        return _length(set._inner);\n', '    }\n', '\n', '    function at(AddressSet storage set, uint256 index) internal view returns (address) {\n', '        return address(uint256(_at(set._inner, index)));\n', '    }\n', '\n', '\n', '    // UintSet\n', '\n', '    struct UintSet {\n', '        Set _inner;\n', '    }\n', '\n', '    function add(UintSet storage set, uint256 value) internal returns (bool) {\n', '        return _add(set._inner, bytes32(value));\n', '    }\n', '\n', '    function remove(UintSet storage set, uint256 value) internal returns (bool) {\n', '        return _remove(set._inner, bytes32(value));\n', '    }\n', '\n', '    /**\n', '     * @dev Returns true if the value is in the set. O(1).\n', '     */\n', '    function contains(UintSet storage set, uint256 value) internal view returns (bool) {\n', '        return _contains(set._inner, bytes32(value));\n', '    }\n', '\n', '    function length(UintSet storage set) internal view returns (uint256) {\n', '        return _length(set._inner);\n', '    }\n', '\n', '    function at(UintSet storage set, uint256 index) internal view returns (uint256) {\n', '        return uint256(_at(set._inner, index));\n', '    }\n', '}\n', '\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  function transferOwnership(address newOwner) onlyOwner public {\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '}\n', '\n', '\n', 'interface Token {\n', '    function transferFrom(address, address, uint) external returns (bool);\n', '    function transfer(address, uint) external returns (bool);\n', '}\n', '\n', 'contract PWTStacking is Ownable {\n', '    using SafeMath for uint;\n', '    using EnumerableSet for EnumerableSet.AddressSet;\n', '    \n', '    event RewardsTransferred(address holder, uint amount);\n', '    \n', '    // PWToken token contract address\n', '    address public constant tokenAddress = 0xD1f6EBb6ADa79817D3dC28e39e7aB1b5E8271201;\n', '    \n', '    // reward rate 120.00% per year\n', '    uint public constant rewardRate = 12000;\n', '    uint public constant rewardInterval = 365 days;  \n', '    \n', '    // staking fee 1 %\n', '    uint public constant stakingFeeRate = 100;\n', '    \n', '    // unstaking fee 1 %\n', '    uint public constant unstakingFeeRate = 100;\n', '    \n', '    // unstaking possible after 48 hours\n', '    uint public constant cliffTime = 48 hours;   // Minimum Staking Period is 2 Days\n', '    \n', '    uint public totalClaimedRewards = 0;\n', '    \n', '    EnumerableSet.AddressSet private holders;\n', '    \n', '    mapping (address => uint) public depositedTokens;\n', '    mapping (address => uint) public stakingTime;\n', '    mapping (address => uint) public lastClaimedTime;\n', '    mapping (address => uint) public totalEarnedTokens;\n', '    \n', '    function updateAccount(address account) private {\n', '        uint pendingDivs = getPendingDivs(account);\n', '        if (pendingDivs > 0) {\n', '            require(Token(tokenAddress).transfer(account, pendingDivs), "Could not transfer tokens.");\n', '            totalEarnedTokens[account] = totalEarnedTokens[account].add(pendingDivs);\n', '            totalClaimedRewards = totalClaimedRewards.add(pendingDivs);\n', '            emit RewardsTransferred(account, pendingDivs);\n', '        }\n', '        lastClaimedTime[account] = now;\n', '    }\n', '    \n', '    function getPendingDivs(address _holder) public view returns (uint) {\n', '        if (!holders.contains(_holder)) return 0;\n', '        if (depositedTokens[_holder] == 0) return 0;\n', '\n', '        uint timeDiff = now.sub(lastClaimedTime[_holder]);\n', '        uint stakedAmount = depositedTokens[_holder];\n', '        \n', '        uint pendingDivs = stakedAmount\n', '                            .mul(rewardRate)\n', '                            .mul(timeDiff)\n', '                            .div(rewardInterval)\n', '                            .div(1e4);\n', '            \n', '        return pendingDivs;\n', '    }\n', '    \n', '    function getNumberOfHolders() public view returns (uint) {\n', '        return holders.length();\n', '    }\n', '    \n', '    \n', '    function deposit(uint amountToStake) public {\n', '        require(amountToStake > 0, "Cannot deposit 0 Tokens");\n', '        require(Token(tokenAddress).transferFrom(msg.sender, address(this), amountToStake), "Insufficient Token Allowance");\n', '        \n', '        updateAccount(msg.sender);\n', '        \n', '        uint fee = amountToStake.mul(stakingFeeRate).div(1e4);\n', '        uint amountAfterFee = amountToStake.sub(fee);\n', '        require(Token(tokenAddress).transfer(owner, fee), "Could not transfer deposit fee.");\n', '        \n', '        depositedTokens[msg.sender] = depositedTokens[msg.sender].add(amountAfterFee);\n', '        \n', '        if (!holders.contains(msg.sender)) {\n', '            holders.add(msg.sender);\n', '            stakingTime[msg.sender] = now;\n', '        }\n', '    }\n', '    \n', '    function withdraw(uint amountToWithdraw) public {\n', '        require(depositedTokens[msg.sender] >= amountToWithdraw, "Invalid amount to withdraw");\n', '        \n', '        require(now.sub(stakingTime[msg.sender]) > cliffTime, "You recently staked, please wait before withdrawing.");\n', '        \n', '        updateAccount(msg.sender);\n', '        \n', '        uint fee = amountToWithdraw.mul(unstakingFeeRate).div(1e4);\n', '        uint amountAfterFee = amountToWithdraw.sub(fee);\n', '        \n', '        require(Token(tokenAddress).transfer(owner, fee), "Could not transfer withdraw fee.");\n', '        require(Token(tokenAddress).transfer(msg.sender, amountAfterFee), "Could not transfer tokens.");\n', '        \n', '        depositedTokens[msg.sender] = depositedTokens[msg.sender].sub(amountToWithdraw);\n', '        \n', '        if (holders.contains(msg.sender) && depositedTokens[msg.sender] == 0) {\n', '            holders.remove(msg.sender);\n', '        }\n', '    }\n', '    \n', '    function claimDivs() public {\n', '        updateAccount(msg.sender);\n', '    }\n', '    \n', '    \n', '    uint private constant stakingAndDaoTokens = 30000e18;   \n', '    // Project Staking upto 30,000 PWT     // 18 Decimals\n', '    \n', '    function getStakingAndDaoAmount() public view returns (uint) {\n', '        if (totalClaimedRewards >= stakingAndDaoTokens) {\n', '            return 0;\n', '        }\n', '        uint remaining = stakingAndDaoTokens.sub(totalClaimedRewards);\n', '        return remaining;\n', '    }\n', '    \n', '    // function to allow admin to claim *other* ERC20 tokens sent to this contract (by mistake)\n', '    function transferAnyERC20Tokens(address _tokenAddr, address _to, uint _amount) public onlyOwner {\n', '        if (_tokenAddr == tokenAddress) {\n', '            if (_amount > getStakingAndDaoAmount()) {\n', '                revert();\n', '            }\n', '            totalClaimedRewards = totalClaimedRewards.add(_amount);\n', '        }\n', '        Token(_tokenAddr).transfer(_to, _amount);\n', '    }\n', '}']