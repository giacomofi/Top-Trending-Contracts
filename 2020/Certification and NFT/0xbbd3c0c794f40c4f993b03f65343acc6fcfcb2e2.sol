['// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.7.0;\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'abstract contract Ownable {\n', '    address private _owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '     * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '     * account.\n', '     */\n', '    constructor () {\n', '        _owner = msg.sender;\n', '        emit OwnershipTransferred(address(0), _owner);\n', '    }\n', '\n', '    /**\n', '     * @return the address of the owner.\n', '     */\n', '    function owner() public view returns (address) {\n', '        return _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(isOwner());\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @return true if `msg.sender` is the owner of the contract.\n', '     */\n', '    function isOwner() public view returns (bool) {\n', '        return msg.sender == _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the current owner to relinquish control of the contract.\n', '     * @notice Renouncing to ownership will leave the contract without an owner.\n', '     * It will not be possible to call the functions with the `onlyOwner`\n', '     * modifier anymore.\n', '     */\n', '    function renounceOwnership() public onlyOwner {\n', '        emit OwnershipTransferred(_owner, address(0));\n', '        _owner = address(0);\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '     * @param newOwner The address to transfer ownership to.\n', '     */\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        _transferOwnership(newOwner);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers control of the contract to a newOwner.\n', '     * @param newOwner The address to transfer ownership to.\n', '     */\n', '    function _transferOwnership(address newOwner) internal {\n', '        require(newOwner != address(0));\n', '        emit OwnershipTransferred(_owner, newOwner);\n', '        _owner = newOwner;\n', '    }\n', '}\n']
['// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.7.0;\n', '\n', '/**\n', ' * @dev Collection of functions related to the address type\n', ' */\n', 'library Address {\n', '    /**\n', '     * @dev Returns true if `account` is a contract.\n', '     *\n', '     * [IMPORTANT]\n', '     * ====\n', '     * It is unsafe to assume that an address for which this function returns\n', '     * false is an externally-owned account (EOA) and not a contract.\n', '     *\n', '     * Among others, `isContract` will return false for the following\n', '     * types of addresses:\n', '     *\n', '     *  - an externally-owned account\n', '     *  - a contract in construction\n', '     *  - an address where a contract will be created\n', '     *  - an address where a contract lived, but was destroyed\n', '     * ====\n', '     */\n', '    function isContract(address account) internal view returns (bool) {\n', '        // According to EIP-1052, 0x0 is the value returned for not-yet created accounts\n', '        // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned\n', "        // for accounts without code, i.e. `keccak256('')`\n", '        bytes32 codehash;\n', '        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;\n', '        // solhint-disable-next-line no-inline-assembly\n', '        assembly { codehash := extcodehash(account) }\n', '        return (codehash != accountHash && codehash != 0x0);\n', '    }\n', '\n', '    /**\n', "     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to\n", '     * `recipient`, forwarding all available gas and reverting on errors.\n', '     *\n', '     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost\n', '     * of certain opcodes, possibly making contracts go over the 2300 gas limit\n', '     * imposed by `transfer`, making them unable to receive funds via\n', '     * `transfer`. {sendValue} removes this limitation.\n', '     *\n', '     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].\n', '     *\n', '     * IMPORTANT: because control is transferred to `recipient`, care must be\n', '     * taken to not create reentrancy vulnerabilities. Consider using\n', '     * {ReentrancyGuard} or the\n', '     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].\n', '     *\n', '     * _Available since v2.4.0._\n', '     */\n', '    function sendValue(address payable recipient, uint256 amount) internal {\n', '        require(address(this).balance >= amount, "Address: insufficient balance");\n', '\n', '        // solhint-disable-next-line avoid-call-value\n', '        (bool success, ) = recipient.call{value: amount}("");\n', '        require(success, "Address: unable to send value, recipient may have reverted");\n', '    }\n', '}\n']
['// SPDX-License-Identifier: AGPL-3.0-or-later\n', '\n', 'pragma solidity ^0.7.0;\n', '\n', '\n', 'import "./Ownable.sol";\n', '\n', '\n', '/**\n', '* @notice Base contract for upgradeable contract\n', '* @dev Inherited contract should implement verifyState(address) method by checking storage variables\n', '* (see verifyState(address) in Dispatcher). Also contract should implement finishUpgrade(address)\n', '* if it is using constructor parameters by coping this parameters to the dispatcher storage\n', '*/\n', 'abstract contract Upgradeable is Ownable {\n', '\n', '    event StateVerified(address indexed testTarget, address sender);\n', '    event UpgradeFinished(address indexed target, address sender);\n', '\n', '    /**\n', '    * @dev Contracts at the target must reserve the same location in storage for this address as in Dispatcher\n', '    * Stored data actually lives in the Dispatcher\n', '    * However the storage layout is specified here in the implementing contracts\n', '    */\n', '    address public target;\n', '\n', '    /**\n', '    * @dev Previous contract address (if available). Used for rollback\n', '    */\n', '    address public previousTarget;\n', '\n', '    /**\n', '    * @dev Upgrade status. Explicit `uint8` type is used instead of `bool` to save gas by excluding 0 value\n', '    */\n', '    uint8 public isUpgrade;\n', '\n', '    /**\n', '    * @dev Guarantees that next slot will be separated from the previous\n', '    */\n', '    uint256 stubSlot;\n', '\n', '    /**\n', '    * @dev Constants for `isUpgrade` field\n', '    */\n', '    uint8 constant UPGRADE_FALSE = 1;\n', '    uint8 constant UPGRADE_TRUE = 2;\n', '\n', '    /**\n', '    * @dev Checks that function executed while upgrading\n', '    * Recommended to add to `verifyState` and `finishUpgrade` methods\n', '    */\n', '    modifier onlyWhileUpgrading()\n', '    {\n', '        require(isUpgrade == UPGRADE_TRUE);\n', '        _;\n', '    }\n', '\n', '    /**\n', '    * @dev Method for verifying storage state.\n', '    * Should check that new target contract returns right storage value\n', '    */\n', '    function verifyState(address _testTarget) public virtual onlyWhileUpgrading {\n', '        emit StateVerified(_testTarget, msg.sender);\n', '    }\n', '\n', '    /**\n', '    * @dev Copy values from the new target to the current storage\n', '    * @param _target New target contract address\n', '    */\n', '    function finishUpgrade(address _target) public virtual onlyWhileUpgrading {\n', '        emit UpgradeFinished(_target, msg.sender);\n', '    }\n', '\n', '    /**\n', '    * @dev Base method to get data\n', '    * @param _target Target to call\n', '    * @param _selector Method selector\n', '    * @param _numberOfArguments Number of used arguments\n', '    * @param _argument1 First method argument\n', '    * @param _argument2 Second method argument\n', '    * @return memoryAddress Address in memory where the data is located\n', '    */\n', '    function delegateGetData(\n', '        address _target,\n', '        bytes4 _selector,\n', '        uint8 _numberOfArguments,\n', '        bytes32 _argument1,\n', '        bytes32 _argument2\n', '    )\n', '        internal returns (bytes32 memoryAddress)\n', '    {\n', '        assembly {\n', '            memoryAddress := mload(0x40)\n', '            mstore(memoryAddress, _selector)\n', '            if gt(_numberOfArguments, 0) {\n', '                mstore(add(memoryAddress, 0x04), _argument1)\n', '            }\n', '            if gt(_numberOfArguments, 1) {\n', '                mstore(add(memoryAddress, 0x24), _argument2)\n', '            }\n', '            switch delegatecall(gas(), _target, memoryAddress, add(0x04, mul(0x20, _numberOfArguments)), 0, 0)\n', '                case 0 {\n', '                    revert(memoryAddress, 0)\n', '                }\n', '                default {\n', '                    returndatacopy(memoryAddress, 0x0, returndatasize())\n', '                }\n', '        }\n', '    }\n', '\n', '    /**\n', '    * @dev Call "getter" without parameters.\n', '    * Result should not exceed 32 bytes\n', '    */\n', '    function delegateGet(address _target, bytes4 _selector)\n', '        internal returns (uint256 result)\n', '    {\n', '        bytes32 memoryAddress = delegateGetData(_target, _selector, 0, 0, 0);\n', '        assembly {\n', '            result := mload(memoryAddress)\n', '        }\n', '    }\n', '\n', '    /**\n', '    * @dev Call "getter" with one parameter.\n', '    * Result should not exceed 32 bytes\n', '    */\n', '    function delegateGet(address _target, bytes4 _selector, bytes32 _argument)\n', '        internal returns (uint256 result)\n', '    {\n', '        bytes32 memoryAddress = delegateGetData(_target, _selector, 1, _argument, 0);\n', '        assembly {\n', '            result := mload(memoryAddress)\n', '        }\n', '    }\n', '\n', '    /**\n', '    * @dev Call "getter" with two parameters.\n', '    * Result should not exceed 32 bytes\n', '    */\n', '    function delegateGet(\n', '        address _target,\n', '        bytes4 _selector,\n', '        bytes32 _argument1,\n', '        bytes32 _argument2\n', '    )\n', '        internal returns (uint256 result)\n', '    {\n', '        bytes32 memoryAddress = delegateGetData(_target, _selector, 2, _argument1, _argument2);\n', '        assembly {\n', '            result := mload(memoryAddress)\n', '        }\n', '    }\n', '}\n']
['// SPDX-License-Identifier: AGPL-3.0-or-later\n', '\n', 'pragma solidity ^0.7.0;\n', '\n', '\n', 'import "./Upgradeable.sol";\n', 'import "./Address.sol";\n', '\n', '\n', '/**\n', '* @notice ERC897 - ERC DelegateProxy\n', '*/\n', 'interface ERCProxy {\n', '    function proxyType() external pure returns (uint256);\n', '    function implementation() external view returns (address);\n', '}\n', '\n', '\n', '/**\n', '* @notice Proxying requests to other contracts.\n', '* Client should use ABI of real contract and address of this contract\n', '*/\n', 'contract Dispatcher is Upgradeable, ERCProxy {\n', '    using Address for address;\n', '\n', '    event Upgraded(address indexed from, address indexed to, address owner);\n', '    event RolledBack(address indexed from, address indexed to, address owner);\n', '\n', '    /**\n', '    * @dev Set upgrading status before and after operations\n', '    */\n', '    modifier upgrading()\n', '    {\n', '        isUpgrade = UPGRADE_TRUE;\n', '        _;\n', '        isUpgrade = UPGRADE_FALSE;\n', '    }\n', '\n', '    /**\n', '    * @param _target Target contract address\n', '    */\n', '    constructor(address _target) upgrading {\n', '        require(_target.isContract());\n', '        // Checks that target contract inherits Dispatcher state\n', '        verifyState(_target);\n', '        // `verifyState` must work with its contract\n', '        verifyUpgradeableState(_target, _target);\n', '        target = _target;\n', '        finishUpgrade();\n', '        emit Upgraded(address(0), _target, msg.sender);\n', '    }\n', '\n', '    //------------------------ERC897------------------------\n', '    /**\n', '     * @notice ERC897, whether it is a forwarding (1) or an upgradeable (2) proxy\n', '     */\n', '    function proxyType() external pure override returns (uint256) {\n', '        return 2;\n', '    }\n', '\n', '    /**\n', '     * @notice ERC897, gets the address of the implementation where every call will be delegated\n', '     */\n', '    function implementation() external view override returns (address) {\n', '        return target;\n', '    }\n', '    //------------------------------------------------------------\n', '\n', '    /**\n', '    * @notice Verify new contract storage and upgrade target\n', '    * @param _target New target contract address\n', '    */\n', '    function upgrade(address _target) public onlyOwner upgrading {\n', '        require(_target.isContract());\n', '        // Checks that target contract has "correct" (as much as possible) state layout\n', '        verifyState(_target);\n', '        //`verifyState` must work with its contract\n', '        verifyUpgradeableState(_target, _target);\n', '        if (target.isContract()) {\n', '            verifyUpgradeableState(target, _target);\n', '        }\n', '        previousTarget = target;\n', '        target = _target;\n', '        finishUpgrade();\n', '        emit Upgraded(previousTarget, _target, msg.sender);\n', '    }\n', '\n', '    /**\n', '    * @notice Rollback to previous target\n', '    * @dev Test storage carefully before upgrade again after rollback\n', '    */\n', '    function rollback() public onlyOwner upgrading {\n', '        require(previousTarget.isContract());\n', '        emit RolledBack(target, previousTarget, msg.sender);\n', '        // should be always true because layout previousTarget -> target was already checked\n', '        // but `verifyState` is not 100% accurate so check again\n', '        verifyState(previousTarget);\n', '        if (target.isContract()) {\n', '            verifyUpgradeableState(previousTarget, target);\n', '        }\n', '        target = previousTarget;\n', '        previousTarget = address(0);\n', '        finishUpgrade();\n', '    }\n', '\n', '    /**\n', '    * @dev Call verifyState method for Upgradeable contract\n', '    */\n', '    function verifyUpgradeableState(address _from, address _to) private {\n', '        (bool callSuccess,) = _from.delegatecall(abi.encodeWithSelector(this.verifyState.selector, _to));\n', '        require(callSuccess);\n', '    }\n', '\n', '    /**\n', '    * @dev Call finishUpgrade method from the Upgradeable contract\n', '    */\n', '    function finishUpgrade() private {\n', '        (bool callSuccess,) = target.delegatecall(abi.encodeWithSelector(this.finishUpgrade.selector, target));\n', '        require(callSuccess);\n', '    }\n', '\n', '    function verifyState(address _testTarget) public override onlyWhileUpgrading {\n', '        //checks equivalence accessing state through new contract and current storage\n', '        require(address(uint160(delegateGet(_testTarget, this.owner.selector))) == owner());\n', '        require(address(uint160(delegateGet(_testTarget, this.target.selector))) == target);\n', '        require(address(uint160(delegateGet(_testTarget, this.previousTarget.selector))) == previousTarget);\n', '        require(uint8(delegateGet(_testTarget, this.isUpgrade.selector)) == isUpgrade);\n', '    }\n', '\n', '    /**\n', '    * @dev Override function using empty code because no reason to call this function in Dispatcher\n', '    */\n', '    function finishUpgrade(address) public override {}\n', '\n', '    /**\n', '    * @dev Receive function sends empty request to the target contract\n', '    */\n', '    receive() external payable {\n', '        assert(target.isContract());\n', '        // execute receive function from target contract using storage of the dispatcher\n', '        (bool callSuccess,) = target.delegatecall("");\n', '        if (!callSuccess) {\n', '            revert();\n', '        }\n', '    }\n', '\n', '    /**\n', '    * @dev Fallback function sends all requests to the target contract\n', '    */\n', '    fallback() external payable {\n', '        assert(target.isContract());\n', '        // execute requested function from target contract using storage of the dispatcher\n', '        (bool callSuccess,) = target.delegatecall(msg.data);\n', '        if (callSuccess) {\n', '            // copy result of the request to the return data\n', '            // we can use the second return value from `delegatecall` (bytes memory)\n', '            // but it will consume a little more gas\n', '            assembly {\n', '                returndatacopy(0x0, 0x0, returndatasize())\n', '                return(0x0, returndatasize())\n', '            }\n', '        } else {\n', '            revert();\n', '        }\n', '    }\n', '\n', '}\n']
