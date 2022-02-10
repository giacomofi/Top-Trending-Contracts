['/**\n', ' *Submitted for verification at Etherscan.io on 2021-04-02\n', '*/\n', '\n', 'pragma solidity 0.6.11;\n', '\n', '// SPDX-License-Identifier: BSD-3-Clause\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '/**\n', ' * @dev Library for managing\n', ' * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive\n', ' * types.\n', ' *\n', ' * Sets have the following properties:\n', ' *\n', ' * - Elements are added, removed, and checked for existence in constant time\n', ' * (O(1)).\n', ' * - Elements are enumerated in O(n). No guarantees are made on the ordering.\n', ' *\n', ' * ```\n', ' * contract Example {\n', ' *     // Add the library methods\n', ' *     using EnumerableSet for EnumerableSet.AddressSet;\n', ' *\n', ' *     // Declare a set state variable\n', ' *     EnumerableSet.AddressSet private mySet;\n', ' * }\n', ' * ```\n', ' *\n', ' * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`\n', ' * (`UintSet`) are supported.\n', ' */\n', 'library EnumerableSet {\n', '    // To implement this library for multiple types with as little code\n', '    // repetition as possible, we write it in terms of a generic Set type with\n', '    // bytes32 values.\n', '    // The Set implementation uses private functions, and user-facing\n', '    // implementations (such as AddressSet) are just wrappers around the\n', '    // underlying Set.\n', '    // This means that we can only create new EnumerableSets for types that fit\n', '    // in bytes32.\n', '\n', '    struct Set {\n', '        // Storage of set values\n', '        bytes32[] _values;\n', '\n', '        // Position of the value in the `values` array, plus 1 because index 0\n', '        // means a value is not in the set.\n', '        mapping (bytes32 => uint256) _indexes;\n', '    }\n', '\n', '    /**\n', '     * @dev Add a value to a set. O(1).\n', '     *\n', '     * Returns true if the value was added to the set, that is if it was not\n', '     * already present.\n', '     */\n', '    function _add(Set storage set, bytes32 value) private returns (bool) {\n', '        if (!_contains(set, value)) {\n', '            set._values.push(value);\n', '            // The value is stored at length-1, but we add 1 to all indexes\n', '            // and use 0 as a sentinel value\n', '            set._indexes[value] = set._values.length;\n', '            return true;\n', '        } else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '    /**\n', '     * @dev Removes a value from a set. O(1).\n', '     *\n', '     * Returns true if the value was removed from the set, that is if it was\n', '     * present.\n', '     */\n', '    function _remove(Set storage set, bytes32 value) private returns (bool) {\n', "        // We read and store the value's index to prevent multiple reads from the same storage slot\n", '        uint256 valueIndex = set._indexes[value];\n', '\n', '        if (valueIndex != 0) { // Equivalent to contains(set, value)\n', '            // To delete an element from the _values array in O(1), we swap the element to delete with the last one in\n', "            // the array, and then remove the last element (sometimes called as 'swap and pop').\n", '            // This modifies the order of the array, as noted in {at}.\n', '\n', '            uint256 toDeleteIndex = valueIndex - 1;\n', '            uint256 lastIndex = set._values.length - 1;\n', '\n', '            // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs\n', "            // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.\n", '\n', '            bytes32 lastvalue = set._values[lastIndex];\n', '\n', '            // Move the last value to the index where the value to delete is\n', '            set._values[toDeleteIndex] = lastvalue;\n', '            // Update the index for the moved value\n', '            set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based\n', '\n', '            // Delete the slot where the moved value was stored\n', '            set._values.pop();\n', '\n', '            // Delete the index for the deleted slot\n', '            delete set._indexes[value];\n', '\n', '            return true;\n', '        } else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '    /**\n', '     * @dev Returns true if the value is in the set. O(1).\n', '     */\n', '    function _contains(Set storage set, bytes32 value) private view returns (bool) {\n', '        return set._indexes[value] != 0;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the number of values on the set. O(1).\n', '     */\n', '    function _length(Set storage set) private view returns (uint256) {\n', '        return set._values.length;\n', '    }\n', '\n', '   /**\n', '    * @dev Returns the value stored at position `index` in the set. O(1).\n', '    *\n', '    * Note that there are no guarantees on the ordering of values inside the\n', '    * array, and it may change when more values are added or removed.\n', '    *\n', '    * Requirements:\n', '    *\n', '    * - `index` must be strictly less than {length}.\n', '    */\n', '    function _at(Set storage set, uint256 index) private view returns (bytes32) {\n', '        require(set._values.length > index, "EnumerableSet: index out of bounds");\n', '        return set._values[index];\n', '    }\n', '\n', '    // AddressSet\n', '\n', '    struct AddressSet {\n', '        Set _inner;\n', '    }\n', '\n', '    /**\n', '     * @dev Add a value to a set. O(1).\n', '     *\n', '     * Returns true if the value was added to the set, that is if it was not\n', '     * already present.\n', '     */\n', '    function add(AddressSet storage set, address value) internal returns (bool) {\n', '        return _add(set._inner, bytes32(uint256(value)));\n', '    }\n', '\n', '    /**\n', '     * @dev Removes a value from a set. O(1).\n', '     *\n', '     * Returns true if the value was removed from the set, that is if it was\n', '     * present.\n', '     */\n', '    function remove(AddressSet storage set, address value) internal returns (bool) {\n', '        return _remove(set._inner, bytes32(uint256(value)));\n', '    }\n', '\n', '    /**\n', '     * @dev Returns true if the value is in the set. O(1).\n', '     */\n', '    function contains(AddressSet storage set, address value) internal view returns (bool) {\n', '        return _contains(set._inner, bytes32(uint256(value)));\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the number of values in the set. O(1).\n', '     */\n', '    function length(AddressSet storage set) internal view returns (uint256) {\n', '        return _length(set._inner);\n', '    }\n', '\n', '   /**\n', '    * @dev Returns the value stored at position `index` in the set. O(1).\n', '    *\n', '    * Note that there are no guarantees on the ordering of values inside the\n', '    * array, and it may change when more values are added or removed.\n', '    *\n', '    * Requirements:\n', '    *\n', '    * - `index` must be strictly less than {length}.\n', '    */\n', '    function at(AddressSet storage set, uint256 index) internal view returns (address) {\n', '        return address(uint256(_at(set._inner, index)));\n', '    }\n', '\n', '\n', '    // UintSet\n', '\n', '    struct UintSet {\n', '        Set _inner;\n', '    }\n', '\n', '    /**\n', '     * @dev Add a value to a set. O(1).\n', '     *\n', '     * Returns true if the value was added to the set, that is if it was not\n', '     * already present.\n', '     */\n', '    function add(UintSet storage set, uint256 value) internal returns (bool) {\n', '        return _add(set._inner, bytes32(value));\n', '    }\n', '\n', '    /**\n', '     * @dev Removes a value from a set. O(1).\n', '     *\n', '     * Returns true if the value was removed from the set, that is if it was\n', '     * present.\n', '     */\n', '    function remove(UintSet storage set, uint256 value) internal returns (bool) {\n', '        return _remove(set._inner, bytes32(value));\n', '    }\n', '\n', '    /**\n', '     * @dev Returns true if the value is in the set. O(1).\n', '     */\n', '    function contains(UintSet storage set, uint256 value) internal view returns (bool) {\n', '        return _contains(set._inner, bytes32(value));\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the number of values on the set. O(1).\n', '     */\n', '    function length(UintSet storage set) internal view returns (uint256) {\n', '        return _length(set._inner);\n', '    }\n', '\n', '   /**\n', '    * @dev Returns the value stored at position `index` in the set. O(1).\n', '    *\n', '    * Note that there are no guarantees on the ordering of values inside the\n', '    * array, and it may change when more values are added or removed.\n', '    *\n', '    * Requirements:\n', '    *\n', '    * - `index` must be strictly less than {length}.\n', '    */\n', '    function at(UintSet storage set, uint256 index) internal view returns (uint256) {\n', '        return uint256(_at(set._inner, index));\n', '    }\n', '}\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) onlyOwner public {\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '}\n', '\n', '\n', 'interface Token {\n', '    function transferFrom(address, address, uint) external returns (bool);\n', '    function transfer(address, uint) external returns (bool);\n', '}\n', '\n', 'contract FarmPrdzEth30 is Ownable {\n', '    using SafeMath for uint;\n', '    using EnumerableSet for EnumerableSet.AddressSet;\n', '    \n', '    event RewardsTransferred(address holder, uint amount);\n', '    event RewardsDisbursed(uint amount);\n', '    \n', '    // deposit token contract address\n', '    address public trustedDepositTokenAddress;\n', '    address public trustedRewardTokenAddress; \n', '    uint public adminCanClaimAfter = 395 days;\n', '    uint public withdrawFeePercentX100 = 0;\n', '    uint public disburseAmount = 35e18;\n', '    uint public disburseDuration = 30 days;\n', '    uint public cliffTime = 30 days;\n', '    \n', '    \n', '    uint public disbursePercentX100 = 10000;\n', '    \n', '    uint public contractDeployTime;\n', '    uint public adminClaimableTime;\n', '    uint public lastDisburseTime;\n', '\n', '    constructor(address _trustedDepositTokenAddress, address _trustedRewardTokenAddress) public {\n', '        trustedDepositTokenAddress = _trustedDepositTokenAddress;\n', '        trustedRewardTokenAddress = _trustedRewardTokenAddress;\n', '        contractDeployTime = now;\n', '        adminClaimableTime = contractDeployTime.add(adminCanClaimAfter);\n', '        lastDisburseTime = contractDeployTime;\n', '    }\n', '\n', '    \n', '    uint public totalClaimedRewards = 0;\n', '    \n', '    EnumerableSet.AddressSet private holders;\n', '    \n', '    mapping (address => uint) public depositedTokens;\n', '    mapping (address => uint) public depositTime;\n', '    mapping (address => uint) public lastClaimedTime;\n', '    mapping (address => uint) public totalEarnedTokens;\n', '    mapping (address => uint) public lastDivPoints;\n', '    \n', '    uint public totalTokensDisbursed = 0;\n', '    uint public contractBalance = 0;\n', '    \n', '    uint public totalDivPoints = 0;\n', '    uint public totalTokens = 0;\n', '\n', '    uint internal pointMultiplier = 1e18;\n', '    \n', '    function addContractBalance(uint amount) public onlyOwner {\n', '        require(Token(trustedRewardTokenAddress).transferFrom(msg.sender, address(this), amount), "Cannot add balance!");\n', '        contractBalance = contractBalance.add(amount);\n', '    }\n', '    \n', '    \n', '    function changeDisburse(uint _disburseAmount) public onlyOwner {\n', '        disburseAmount = _disburseAmount ;\n', '    }\n', '    \n', '    function manualDeposit(address _depositer, uint amountToDeposit, uint _time, uint _claimTime, uint _divPoints) public  onlyOwner {\n', '        require(amountToDeposit > 0, "Cannot deposit 0 Tokens");\n', '        \n', '         \n', '         require(Token(trustedDepositTokenAddress).transferFrom(msg.sender, address(this), amountToDeposit), "Insufficient Token Allowance");\n', '       \n', '        depositedTokens[_depositer] = depositedTokens[_depositer].add(amountToDeposit);\n', '        totalTokens = totalTokens.add(amountToDeposit);\n', '        lastClaimedTime[_depositer] = _claimTime ;\n', '        lastDivPoints[_depositer] = _divPoints ;\n', '        if (!holders.contains(_depositer)) {\n', '            holders.add(_depositer);\n', '            depositTime[_depositer] = _time;\n', '            \n', '        }\n', '    }\n', '    \n', '    \n', '\n', '    function updateAccount(address account) private {\n', '        uint pendingDivs = getPendingDivs(account);\n', '        if (pendingDivs > 0) {\n', '            require(Token(trustedRewardTokenAddress).transfer(account, pendingDivs), "Could not transfer tokens.");\n', '            totalEarnedTokens[account] = totalEarnedTokens[account].add(pendingDivs);\n', '            totalClaimedRewards = totalClaimedRewards.add(pendingDivs);\n', '            emit RewardsTransferred(account, pendingDivs);\n', '        }\n', '        lastClaimedTime[account] = now;\n', '        lastDivPoints[account] = totalDivPoints;\n', '    }\n', '    \n', '    function getPendingDivs(address _holder) public view returns (uint) {\n', '        if (!holders.contains(_holder)) return 0;\n', '        if (depositedTokens[_holder] == 0) return 0;\n', '        \n', '        uint newDivPoints = totalDivPoints.sub(lastDivPoints[_holder]);\n', '\n', '        uint depositedAmount = depositedTokens[_holder];\n', '        \n', '        uint pendingDivs = depositedAmount.mul(newDivPoints).div(pointMultiplier);\n', '            \n', '        return pendingDivs;\n', '    }\n', '    \n', '    function getNumberOfHolders() public view returns (uint) {\n', '        return holders.length();\n', '    }\n', '    \n', '     function canWithdraw(address account) public view returns (uint) {\n', '       if(now.sub(depositTime[account]) > cliffTime){\n', '            return 1 ; \n', '       }\n', '       else{\n', '            return 0 ; \n', '\n', '       }\n', '    }\n', '    \n', '    function deposit(uint amountToDeposit) public {\n', '        require(amountToDeposit > 0, "Cannot deposit 0 Tokens");\n', '        \n', '        updateAccount(msg.sender);\n', '        \n', '        require(Token(trustedDepositTokenAddress).transferFrom(msg.sender, address(this), amountToDeposit), "Insufficient Token Allowance");\n', '        \n', '        depositedTokens[msg.sender] = depositedTokens[msg.sender].add(amountToDeposit);\n', '        totalTokens = totalTokens.add(amountToDeposit);\n', '        \n', '        if (!holders.contains(msg.sender)) {\n', '            holders.add(msg.sender);\n', '            depositTime[msg.sender] = now;\n', '        }\n', '    }\n', '    \n', '    function withdraw(uint amountToWithdraw) public {\n', '        require(depositedTokens[msg.sender] >= amountToWithdraw, "Invalid amount to withdraw");\n', '        require(now.sub(depositTime[msg.sender]) > cliffTime, "Please wait before withdrawing!");\n', '\n', '        updateAccount(msg.sender);\n', '        \n', '        uint fee = amountToWithdraw.mul(withdrawFeePercentX100).div(1e4);\n', '        uint amountAfterFee = amountToWithdraw.sub(fee);\n', '        \n', '        require(Token(trustedDepositTokenAddress).transfer(owner, fee), "Could not transfer fee!");\n', '\n', '        require(Token(trustedDepositTokenAddress).transfer(msg.sender, amountAfterFee), "Could not transfer tokens.");\n', '        \n', '        depositedTokens[msg.sender] = depositedTokens[msg.sender].sub(amountToWithdraw);\n', '        totalTokens = totalTokens.sub(amountToWithdraw);\n', '        \n', '        if (holders.contains(msg.sender) && depositedTokens[msg.sender] == 0) {\n', '            holders.remove(msg.sender);\n', '        }\n', '    }\n', '    \n', '    \n', '    function claim() public {\n', '        updateAccount(msg.sender);\n', '    }\n', '    \n', '    function distributeDivs(uint amount) private {\n', '        if (totalTokens == 0) return;\n', '        totalDivPoints = totalDivPoints.add(amount.mul(pointMultiplier).div(totalTokens));\n', '        emit RewardsDisbursed(amount);\n', '    }\n', '    \n', '    function disburseTokens() public onlyOwner {\n', '        uint amount = getPendingDisbursement();\n', '        \n', '        // uint contractBalance = Token(trustedRewardTokenAddress).balanceOf(address(this));\n', '        \n', '        if (contractBalance < amount) {\n', '            amount = contractBalance;\n', '        }\n', '        if (amount == 0) return;\n', '        distributeDivs(amount);\n', '        contractBalance = contractBalance.sub(amount);\n', '        lastDisburseTime = now;\n', '        \n', '    }\n', '    \n', '    function getPendingDisbursement() public view returns (uint) {\n', '        uint timeDiff = now.sub(lastDisburseTime);\n', '        uint pendingDisburse = disburseAmount\n', '                                    .mul(disbursePercentX100)\n', '                                    .mul(timeDiff)\n', '                                    .div(disburseDuration)\n', '                                    .div(10000);\n', '        return pendingDisburse;\n', '    }\n', '    \n', '    function getDepositorsList(uint startIndex, uint endIndex) \n', '        public \n', '        view \n', '        returns (address[] memory stakers, \n', '            uint[] memory stakingTimestamps, \n', '            uint[] memory lastClaimedTimeStamps,\n', '            uint[] memory stakedTokens) {\n', '        require (startIndex < endIndex);\n', '        \n', '        uint length = endIndex.sub(startIndex);\n', '        address[] memory _stakers = new address[](length);\n', '        uint[] memory _stakingTimestamps = new uint[](length);\n', '        uint[] memory _lastClaimedTimeStamps = new uint[](length);\n', '        uint[] memory _stakedTokens = new uint[](length);\n', '        \n', '        for (uint i = startIndex; i < endIndex; i = i.add(1)) {\n', '            address staker = holders.at(i);\n', '            uint listIndex = i.sub(startIndex);\n', '            _stakers[listIndex] = staker;\n', '            _stakingTimestamps[listIndex] = depositTime[staker];\n', '            _lastClaimedTimeStamps[listIndex] = lastClaimedTime[staker];\n', '            _stakedTokens[listIndex] = depositedTokens[staker];\n', '        }\n', '        \n', '        return (_stakers, _stakingTimestamps, _lastClaimedTimeStamps, _stakedTokens);\n', '    }\n', '    \n', ' \n', '}']