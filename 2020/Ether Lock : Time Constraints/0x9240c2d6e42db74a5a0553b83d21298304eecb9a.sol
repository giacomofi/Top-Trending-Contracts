['pragma solidity 0.6.12;\n', '\n', '// SPDX-License-Identifier: BSD-3-Clause\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '/**\n', ' * @dev Library for managing\n', ' * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive\n', ' * types.\n', ' *\n', ' * Sets have the following properties:\n', ' *\n', ' * - Elements are added, removed, and checked for existence in constant time\n', ' * (O(1)).\n', ' * - Elements are enumerated in O(n). No guarantees are made on the ordering.\n', ' *\n', ' * ```\n', ' * contract Example {\n', ' *     // Add the library methods\n', ' *     using EnumerableSet for EnumerableSet.AddressSet;\n', ' *\n', ' *     // Declare a set state variable\n', ' *     EnumerableSet.AddressSet private mySet;\n', ' * }\n', ' * ```\n', ' *\n', ' * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`\n', ' * (`UintSet`) are supported.\n', ' */\n', 'library EnumerableSet {\n', '    // To implement this library for multiple types with as little code\n', '    // repetition as possible, we write it in terms of a generic Set type with\n', '    // bytes32 values.\n', '    // The Set implementation uses private functions, and user-facing\n', '    // implementations (such as AddressSet) are just wrappers around the\n', '    // underlying Set.\n', '    // This means that we can only create new EnumerableSets for types that fit\n', '    // in bytes32.\n', '\n', '    struct Set {\n', '        // Storage of set values\n', '        bytes32[] _values;\n', '\n', '        // Position of the value in the `values` array, plus 1 because index 0\n', '        // means a value is not in the set.\n', '        mapping (bytes32 => uint256) _indexes;\n', '    }\n', '\n', '    /**\n', '     * @dev Add a value to a set. O(1).\n', '     *\n', '     * Returns true if the value was added to the set, that is if it was not\n', '     * already present.\n', '     */\n', '    function _add(Set storage set, bytes32 value) private returns (bool) {\n', '        if (!_contains(set, value)) {\n', '            set._values.push(value);\n', '            // The value is stored at length-1, but we add 1 to all indexes\n', '            // and use 0 as a sentinel value\n', '            set._indexes[value] = set._values.length;\n', '            return true;\n', '        } else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '    /**\n', '     * @dev Removes a value from a set. O(1).\n', '     *\n', '     * Returns true if the value was removed from the set, that is if it was\n', '     * present.\n', '     */\n', '    function _remove(Set storage set, bytes32 value) private returns (bool) {\n', "        // We read and store the value's index to prevent multiple reads from the same storage slot\n", '        uint256 valueIndex = set._indexes[value];\n', '\n', '        if (valueIndex != 0) { // Equivalent to contains(set, value)\n', '            // To delete an element from the _values array in O(1), we swap the element to delete with the last one in\n', "            // the array, and then remove the last element (sometimes called as 'swap and pop').\n", '            // This modifies the order of the array, as noted in {at}.\n', '\n', '            uint256 toDeleteIndex = valueIndex - 1;\n', '            uint256 lastIndex = set._values.length - 1;\n', '\n', '            // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs\n', "            // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.\n", '\n', '            bytes32 lastvalue = set._values[lastIndex];\n', '\n', '            // Move the last value to the index where the value to delete is\n', '            set._values[toDeleteIndex] = lastvalue;\n', '            // Update the index for the moved value\n', '            set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based\n', '\n', '            // Delete the slot where the moved value was stored\n', '            set._values.pop();\n', '\n', '            // Delete the index for the deleted slot\n', '            delete set._indexes[value];\n', '\n', '            return true;\n', '        } else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '    /**\n', '     * @dev Returns true if the value is in the set. O(1).\n', '     */\n', '    function _contains(Set storage set, bytes32 value) private view returns (bool) {\n', '        return set._indexes[value] != 0;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the number of values on the set. O(1).\n', '     */\n', '    function _length(Set storage set) private view returns (uint256) {\n', '        return set._values.length;\n', '    }\n', '\n', '   /**\n', '    * @dev Returns the value stored at position `index` in the set. O(1).\n', '    *\n', '    * Note that there are no guarantees on the ordering of values inside the\n', '    * array, and it may change when more values are added or removed.\n', '    *\n', '    * Requirements:\n', '    *\n', '    * - `index` must be strictly less than {length}.\n', '    */\n', '    function _at(Set storage set, uint256 index) private view returns (bytes32) {\n', '        require(set._values.length > index, "EnumerableSet: index out of bounds");\n', '        return set._values[index];\n', '    }\n', '\n', '    // AddressSet\n', '\n', '    struct AddressSet {\n', '        Set _inner;\n', '    }\n', '\n', '    /**\n', '     * @dev Add a value to a set. O(1).\n', '     *\n', '     * Returns true if the value was added to the set, that is if it was not\n', '     * already present.\n', '     */\n', '    function add(AddressSet storage set, address value) internal returns (bool) {\n', '        return _add(set._inner, bytes32(uint256(value)));\n', '    }\n', '\n', '    /**\n', '     * @dev Removes a value from a set. O(1).\n', '     *\n', '     * Returns true if the value was removed from the set, that is if it was\n', '     * present.\n', '     */\n', '    function remove(AddressSet storage set, address value) internal returns (bool) {\n', '        return _remove(set._inner, bytes32(uint256(value)));\n', '    }\n', '\n', '    /**\n', '     * @dev Returns true if the value is in the set. O(1).\n', '     */\n', '    function contains(AddressSet storage set, address value) internal view returns (bool) {\n', '        return _contains(set._inner, bytes32(uint256(value)));\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the number of values in the set. O(1).\n', '     */\n', '    function length(AddressSet storage set) internal view returns (uint256) {\n', '        return _length(set._inner);\n', '    }\n', '\n', '   /**\n', '    * @dev Returns the value stored at position `index` in the set. O(1).\n', '    *\n', '    * Note that there are no guarantees on the ordering of values inside the\n', '    * array, and it may change when more values are added or removed.\n', '    *\n', '    * Requirements:\n', '    *\n', '    * - `index` must be strictly less than {length}.\n', '    */\n', '    function at(AddressSet storage set, uint256 index) internal view returns (address) {\n', '        return address(uint256(_at(set._inner, index)));\n', '    }\n', '\n', '\n', '    // UintSet\n', '\n', '    struct UintSet {\n', '        Set _inner;\n', '    }\n', '\n', '    /**\n', '     * @dev Add a value to a set. O(1).\n', '     *\n', '     * Returns true if the value was added to the set, that is if it was not\n', '     * already present.\n', '     */\n', '    function add(UintSet storage set, uint256 value) internal returns (bool) {\n', '        return _add(set._inner, bytes32(value));\n', '    }\n', '\n', '    /**\n', '     * @dev Removes a value from a set. O(1).\n', '     *\n', '     * Returns true if the value was removed from the set, that is if it was\n', '     * present.\n', '     */\n', '    function remove(UintSet storage set, uint256 value) internal returns (bool) {\n', '        return _remove(set._inner, bytes32(value));\n', '    }\n', '\n', '    /**\n', '     * @dev Returns true if the value is in the set. O(1).\n', '     */\n', '    function contains(UintSet storage set, uint256 value) internal view returns (bool) {\n', '        return _contains(set._inner, bytes32(value));\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the number of values on the set. O(1).\n', '     */\n', '    function length(UintSet storage set) internal view returns (uint256) {\n', '        return _length(set._inner);\n', '    }\n', '\n', '   /**\n', '    * @dev Returns the value stored at position `index` in the set. O(1).\n', '    *\n', '    * Note that there are no guarantees on the ordering of values inside the\n', '    * array, and it may change when more values are added or removed.\n', '    *\n', '    * Requirements:\n', '    *\n', '    * - `index` must be strictly less than {length}.\n', '    */\n', '    function at(UintSet storage set, uint256 index) internal view returns (uint256) {\n', '        return uint256(_at(set._inner, index));\n', '    }\n', '}\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address payable public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address payable newOwner) onlyOwner public {\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '}\n', '\n', '\n', 'interface Token {\n', '    function transferFrom(address, address, uint) external returns (bool);\n', '    function transfer(address, uint) external returns (bool);\n', '}\n', '\n', 'contract xSTAKEfinance is Ownable {\n', '    using SafeMath for uint;\n', '    using EnumerableSet for EnumerableSet.AddressSet;\n', '    \n', '    event RewardsTransferred(address holder, uint amount);\n', '    \n', '    // staking token contract address\n', '    address public constant tokenAddress = 0xb6aa337C9005FBf3a10Edde47DDde3541adb79Cb;\n', '    \n', '    // reward rate 220.00% per year\n', '    uint public constant rewardRate = 22000;\n', '    uint public constant rewardInterval = 365 days;\n', '    \n', '    uint public constant fee = 1e16;\n', '    \n', '    // unstaking possible after 7 days\n', '    uint public constant cliffTime = 7 days;\n', '    \n', '    uint public totalClaimedRewards = 0;\n', '    \n', '    EnumerableSet.AddressSet private holders;\n', '    \n', '    mapping (address => uint) public depositedTokens;\n', '    mapping (address => uint) public stakingTime;\n', '    mapping (address => uint) public lastClaimedTime;\n', '    mapping (address => uint) public totalEarnedTokens;\n', '    \n', '    function updateAccount(address account) private {\n', '        uint pendingDivs = getPendingDivs(account);\n', '        if (pendingDivs > 0) {\n', '            require(Token(tokenAddress).transfer(account, pendingDivs), "Could not transfer tokens.");\n', '            totalEarnedTokens[account] = totalEarnedTokens[account].add(pendingDivs);\n', '            totalClaimedRewards = totalClaimedRewards.add(pendingDivs);\n', '            emit RewardsTransferred(account, pendingDivs);\n', '        }\n', '        lastClaimedTime[account] = now;\n', '    }\n', '    \n', '    function getPendingDivs(address _holder) public view returns (uint) {\n', '        if (!holders.contains(_holder)) return 0;\n', '        if (depositedTokens[_holder] == 0) return 0;\n', '\n', '        uint timeDiff = now.sub(lastClaimedTime[_holder]);\n', '        uint stakedAmount = depositedTokens[_holder];\n', '        \n', '        uint pendingDivs = stakedAmount\n', '                            .mul(rewardRate)\n', '                            .mul(timeDiff)\n', '                            .div(rewardInterval)\n', '                            .div(1e4);\n', '            \n', '        return pendingDivs;\n', '    }\n', '    \n', '    function getNumberOfStakers() public view returns (uint) {\n', '        return holders.length();\n', '    }\n', '    \n', '    \n', '    function stake(uint amountToStake) payable public {\n', '        require(msg.value >= fee, "Insufficient fee deposited.");\n', '        owner.transfer(msg.value);\n', '        \n', '        require(amountToStake > 0, "Cannot deposit 0 Tokens");\n', '        require(Token(tokenAddress).transferFrom(msg.sender, address(this), amountToStake), "Insufficient Token Allowance");\n', '        \n', '        updateAccount(msg.sender);\n', '        \n', '        depositedTokens[msg.sender] = depositedTokens[msg.sender].add(amountToStake);\n', '        \n', '        if (!holders.contains(msg.sender)) {\n', '            holders.add(msg.sender);\n', '            stakingTime[msg.sender] = now;\n', '        }\n', '    }\n', '    \n', '    function unstake(uint amountToWithdraw) payable public {\n', '        require(msg.value >= fee, "Insufficient fee deposited.");\n', '        owner.transfer(msg.value);\n', '        require(depositedTokens[msg.sender] >= amountToWithdraw, "Invalid amount to withdraw");\n', '        \n', '        require(now.sub(stakingTime[msg.sender]) > cliffTime, "You recently staked, please wait before withdrawing.");\n', '        \n', '        updateAccount(msg.sender);\n', '\n', '        require(Token(tokenAddress).transfer(msg.sender, amountToWithdraw), "Could not transfer tokens.");\n', '        \n', '        depositedTokens[msg.sender] = depositedTokens[msg.sender].sub(amountToWithdraw);\n', '        \n', '        if (holders.contains(msg.sender) && depositedTokens[msg.sender] == 0) {\n', '            holders.remove(msg.sender);\n', '        }\n', '    }\n', '    \n', '    function claim() public {\n', '        updateAccount(msg.sender);\n', '    }\n', '    \n', '    uint private constant stakingTokens = 680000e18;\n', '    \n', '    function getStakingAmount() public view returns (uint) {\n', '        if (totalClaimedRewards >= stakingTokens) {\n', '            return 0;\n', '        }\n', '        uint remaining = stakingTokens.sub(totalClaimedRewards);\n', '        return remaining;\n', '    }\n', '    \n', '    // function to allow owner to claim *other* ERC20 tokens sent to this contract\n', '    function transferAnyERC20Tokens(address _tokenAddr, address _to, uint _amount) public onlyOwner {\n', '        if (_tokenAddr == tokenAddress) {\n', '                revert();\n', '        }\n', '        Token(_tokenAddr).transfer(_to, _amount);\n', '    }\n', '}']