['/**\n', ' *Submitted for verification at Etherscan.io on 2021-06-22\n', '*/\n', '\n', '// File: contracts/Ownable.sol\n', '\n', 'pragma solidity =0.5.16;\n', '\n', '/**\n', ' * @dev Contract module which provides a basic access control mechanism, where\n', ' * there is an account (an owner) that can be granted exclusive access to\n', ' * specific functions.\n', ' *\n', ' * This module is used through inheritance. It will make available the modifier\n', ' * `onlyOwner`, which can be applied to your functions to restrict their use to\n', ' * the owner.\n', ' */\n', 'contract Ownable {\n', '    address internal _owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '     * @dev Initializes the contract setting the deployer as the initial owner.\n', '     */\n', '    constructor() internal {\n', '        _owner = msg.sender;\n', '        emit OwnershipTransferred(address(0), _owner);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the address of the current owner.\n', '     */\n', '    function owner() public view returns (address) {\n', '        return _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(isOwner(), "Ownable: caller is not the owner");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns true if the caller is the current owner.\n', '     */\n', '    function isOwner() public view returns (bool) {\n', '        return msg.sender == _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Leaves the contract without owner. It will not be possible to call\n', '     * `onlyOwner` functions anymore. Can only be called by the current owner.\n', '     *\n', '     * NOTE: Renouncing ownership will leave the contract without an owner,\n', '     * thereby removing any functionality that is only available to the owner.\n', '     */\n', '    function renounceOwnership() public onlyOwner {\n', '        emit OwnershipTransferred(_owner, address(0));\n', '        _owner = address(0);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n', '     * Can only be called by the current owner.\n', '     */\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        _transferOwnership(newOwner);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n', '     */\n', '    function _transferOwnership(address newOwner) internal {\n', '        require(newOwner != address(0), "Ownable: new owner is the zero address");\n', '        emit OwnershipTransferred(_owner, newOwner);\n', '        _owner = newOwner;\n', '    }\n', '}\n', '\n', '// File: contracts/Halt.sol\n', '\n', 'pragma solidity =0.5.16;\n', '\n', '\n', 'contract Halt is Ownable {\n', '    \n', '    bool private halted = false; \n', '    \n', '    modifier notHalted() {\n', '        require(!halted,"This contract is halted");\n', '        _;\n', '    }\n', '\n', '    modifier isHalted() {\n', '        require(halted,"This contract is not halted");\n', '        _;\n', '    }\n', '    \n', '    /// @notice function Emergency situation that requires \n', '    /// @notice contribution period to stop or not.\n', '    function setHalt(bool halt) \n', '        public \n', '        onlyOwner\n', '    {\n', '        halted = halt;\n', '    }\n', '}\n', '\n', '// File: contracts/whiteList.sol\n', '\n', 'pragma solidity >=0.5.16;\n', '/**\n', ' * SPDX-License-Identifier: GPL-3.0-or-later\n', ' * FinNexus\n', ' * Copyright (C) 2020 FinNexus Options Protocol\n', ' */\n', '    /**\n', '     * @dev Implementation of a whitelist which filters a eligible uint32.\n', '     */\n', 'library whiteListUint32 {\n', '    /**\n', '     * @dev add uint32 into white list.\n', '     * @param whiteList the storage whiteList.\n', '     * @param temp input value\n', '     */\n', '\n', '    function addWhiteListUint32(uint32[] storage whiteList,uint32 temp) internal{\n', '        if (!isEligibleUint32(whiteList,temp)){\n', '            whiteList.push(temp);\n', '        }\n', '    }\n', '    /**\n', '     * @dev remove uint32 from whitelist.\n', '     */\n', '    function removeWhiteListUint32(uint32[] storage whiteList,uint32 temp)internal returns (bool) {\n', '        uint256 len = whiteList.length;\n', '        uint256 i=0;\n', '        for (;i<len;i++){\n', '            if (whiteList[i] == temp)\n', '                break;\n', '        }\n', '        if (i<len){\n', '            if (i!=len-1) {\n', '                whiteList[i] = whiteList[len-1];\n', '            }\n', '            whiteList.length--;\n', '            return true;\n', '        }\n', '        return false;\n', '    }\n', '    function isEligibleUint32(uint32[] memory whiteList,uint32 temp) internal pure returns (bool){\n', '        uint256 len = whiteList.length;\n', '        for (uint256 i=0;i<len;i++){\n', '            if (whiteList[i] == temp)\n', '                return true;\n', '        }\n', '        return false;\n', '    }\n', '    function _getEligibleIndexUint32(uint32[] memory whiteList,uint32 temp) internal pure returns (uint256){\n', '        uint256 len = whiteList.length;\n', '        uint256 i=0;\n', '        for (;i<len;i++){\n', '            if (whiteList[i] == temp)\n', '                break;\n', '        }\n', '        return i;\n', '    }\n', '}\n', '    /**\n', '     * @dev Implementation of a whitelist which filters a eligible uint256.\n', '     */\n', 'library whiteListUint256 {\n', '    // add whiteList\n', '    function addWhiteListUint256(uint256[] storage whiteList,uint256 temp) internal{\n', '        if (!isEligibleUint256(whiteList,temp)){\n', '            whiteList.push(temp);\n', '        }\n', '    }\n', '    function removeWhiteListUint256(uint256[] storage whiteList,uint256 temp)internal returns (bool) {\n', '        uint256 len = whiteList.length;\n', '        uint256 i=0;\n', '        for (;i<len;i++){\n', '            if (whiteList[i] == temp)\n', '                break;\n', '        }\n', '        if (i<len){\n', '            if (i!=len-1) {\n', '                whiteList[i] = whiteList[len-1];\n', '            }\n', '            whiteList.length--;\n', '            return true;\n', '        }\n', '        return false;\n', '    }\n', '    function isEligibleUint256(uint256[] memory whiteList,uint256 temp) internal pure returns (bool){\n', '        uint256 len = whiteList.length;\n', '        for (uint256 i=0;i<len;i++){\n', '            if (whiteList[i] == temp)\n', '                return true;\n', '        }\n', '        return false;\n', '    }\n', '    function _getEligibleIndexUint256(uint256[] memory whiteList,uint256 temp) internal pure returns (uint256){\n', '        uint256 len = whiteList.length;\n', '        uint256 i=0;\n', '        for (;i<len;i++){\n', '            if (whiteList[i] == temp)\n', '                break;\n', '        }\n', '        return i;\n', '    }\n', '}\n', '    /**\n', '     * @dev Implementation of a whitelist which filters a eligible address.\n', '     */\n', 'library whiteListAddress {\n', '    // add whiteList\n', '    function addWhiteListAddress(address[] storage whiteList,address temp) internal{\n', '        if (!isEligibleAddress(whiteList,temp)){\n', '            whiteList.push(temp);\n', '        }\n', '    }\n', '    function removeWhiteListAddress(address[] storage whiteList,address temp)internal returns (bool) {\n', '        uint256 len = whiteList.length;\n', '        uint256 i=0;\n', '        for (;i<len;i++){\n', '            if (whiteList[i] == temp)\n', '                break;\n', '        }\n', '        if (i<len){\n', '            if (i!=len-1) {\n', '                whiteList[i] = whiteList[len-1];\n', '            }\n', '            whiteList.length--;\n', '            return true;\n', '        }\n', '        return false;\n', '    }\n', '    function isEligibleAddress(address[] memory whiteList,address temp) internal pure returns (bool){\n', '        uint256 len = whiteList.length;\n', '        for (uint256 i=0;i<len;i++){\n', '            if (whiteList[i] == temp)\n', '                return true;\n', '        }\n', '        return false;\n', '    }\n', '    function _getEligibleIndexAddress(address[] memory whiteList,address temp) internal pure returns (uint256){\n', '        uint256 len = whiteList.length;\n', '        uint256 i=0;\n', '        for (;i<len;i++){\n', '            if (whiteList[i] == temp)\n', '                break;\n', '        }\n', '        return i;\n', '    }\n', '}\n', '\n', '// File: contracts/Operator.sol\n', '\n', 'pragma solidity =0.5.16;\n', '\n', '\n', '/**\n', ' * @dev Contract module which provides a basic access control mechanism, where\n', ' * each operator can be granted exclusive access to specific functions.\n', ' *\n', ' */\n', 'contract Operator is Ownable {\n', '    mapping(uint256=>address) private _operators;\n', '    /**\n', '     * @dev modifier, Only indexed operator can be granted exclusive access to specific functions. \n', '     *\n', '     */\n', '    modifier onlyOperator(uint256 index) {\n', '        require(_operators[index] == msg.sender,"Operator: caller is not the eligible Operator");\n', '        _;\n', '    }\n', '    /**\n', '     * @dev modify indexed operator by owner. \n', '     *\n', '     */\n', '    function setOperator(uint256 index,address addAddress)public onlyOwner{\n', '        _operators[index] = addAddress;\n', '    }\n', '    function getOperator(uint256 index)public view returns (address) {\n', '        return _operators[index];\n', '    }\n', '}\n', '\n', '// File: contracts/multiSignatureClient.sol\n', '\n', 'pragma solidity =0.5.16;\n', 'interface IMultiSignature{\n', '    function getValidSignature(bytes32 msghash,uint256 lastIndex) external view returns(uint256);\n', '}\n', 'contract multiSignatureClient{\n', '    bytes32 private constant multiSignaturePositon = keccak256("org.Finnexus.multiSignature.storage");\n', '    constructor(address multiSignature) public {\n', '        require(multiSignature != address(0),"multiSignatureClient : Multiple signature contract address is zero!");\n', '        saveValue(multiSignaturePositon,uint256(multiSignature));\n', '    }    \n', '    function getMultiSignatureAddress()public view returns (address){\n', '        return address(getValue(multiSignaturePositon));\n', '    }\n', '    modifier validCall(){\n', '        checkMultiSignature();\n', '        _;\n', '    }\n', '    function checkMultiSignature() internal {\n', '        uint256 value;\n', '        assembly {\n', '            value := callvalue()\n', '        }\n', '        bytes32 msgHash = keccak256(abi.encodePacked(msg.sender, address(this),value,msg.data));\n', '        address multiSign = getMultiSignatureAddress();\n', '        uint256 index = getValue(msgHash);\n', '        uint256 newIndex = IMultiSignature(multiSign).getValidSignature(msgHash,index);\n', '        require(newIndex > 0, "multiSignatureClient : This tx is not aprroved");\n', '        saveValue(msgHash,newIndex);\n', '    }\n', '    function saveValue(bytes32 position,uint256 value) internal \n', '    {\n', '        assembly {\n', '            sstore(position, value)\n', '        }\n', '    }\n', '    function getValue(bytes32 position) internal view returns (uint256 value) {\n', '        assembly {\n', '            value := sload(position)\n', '        }\n', '    }\n', '}\n', '\n', '// File: contracts/TokenUnlockData.sol\n', '\n', 'pragma solidity =0.5.16;\n', '\n', '\n', '\n', 'contract TokenUnlockData is multiSignatureClient,Operator,Halt {\n', '    //the locjed reward info\n', '\n', '    struct lockedItem {\n', '        uint256 startTime; //this tx startTime for locking\n', '        uint256 endTime;   //record input amount in each lock tx\n', '        uint256 amount;\n', '    }\n', '\n', '    struct lockedInfo {\n', '        uint256 wholeAmount;\n', '        uint256 pendingAmount;     //record input amount in each lock tx\n', '        uint256 totalItem;\n', '        bool    disable;\n', '        mapping (uint256 => lockedItem) alloc;//the allocation table\n', '    }\n', '\n', '    address public phxAddress;  //fnx token address\n', '\n', '    mapping (address => lockedInfo) public allLockedPhx;//converting tx record for each user\n', '\n', '    event SetUserPhxAlloc(address indexed owner, uint256 indexed amount,uint256 indexed worth);\n', '\n', '    event ClaimPhx(address indexed owner, uint256 indexed amount,uint256 indexed worth);\n', '\n', '}\n', '\n', '// File: contracts/proxy/ZiplinProxy.sol\n', '\n', 'pragma solidity =0.5.16;\n', '\n', 'library ZOSLibAddress {\n', '    /**\n', '     * Returns whether the target address is a contract\n', '     * @dev This function will return false if invoked during the constructor of a contract,\n', '     * as the code is not actually created until after the constructor finishes.\n', '     * @param account address of the account to check\n', '     * @return whether the target address is a contract\n', '     */\n', '    function isContract(address account) internal view returns (bool) {\n', '        uint256 size;\n', '        // XXX Currently there is no better way to check if there is a contract in an address\n', '        // than to check the size of the code at that address.\n', '        // See https://ethereum.stackexchange.com/a/14016/36603\n', '        // for more details about how this works.\n', '        // TODO Check this again before the Serenity release, because all addresses will be\n', '        // contracts then.\n', '        // solhint-disable-next-line no-inline-assembly\n', '        assembly { size := extcodesize(account) }\n', '        return size > 0;\n', '    }\n', '}\n', '\n', '/**\n', ' * @title Proxy\n', ' * @dev Implements delegation of calls to other contracts, with proper\n', ' * forwarding of return values and bubbling of failures.\n', ' * It defines a fallback function that delegates all calls to the address\n', ' * returned by the abstract _implementation() internal function.\n', ' */\n', 'contract Proxy {\n', '    /**\n', '     * @dev Fallback function.\n', '     * Implemented entirely in `_fallback`.\n', '     */\n', '    function () payable external {\n', '        _fallback();\n', '    }\n', '\n', '    /**\n', '     * @return The Address of the implementation.\n', '     */\n', '    function _implementation() internal view returns (address);\n', '\n', '    /**\n', '     * @dev Delegates execution to an implementation contract.\n', "     * This is a low level function that doesn't return to its internal call site.\n", '     * It will return to the external caller whatever the implementation returns.\n', '     * @param implementation Address to delegate.\n', '     */\n', '    function _delegate(address implementation) internal {\n', '        assembly {\n', '        // Copy msg.data. We take full control of memory in this inline assembly\n', '        // block because it will not return to Solidity code. We overwrite the\n', '        // Solidity scratch pad at memory position 0.\n', '            calldatacopy(0, 0, calldatasize)\n', '\n', '        // Call the implementation.\n', "        // out and outsize are 0 because we don't know the size yet.\n", '            let result := delegatecall(gas, implementation, 0, calldatasize, 0, 0)\n', '\n', '        // Copy the returned data.\n', '            returndatacopy(0, 0, returndatasize)\n', '\n', '            switch result\n', '            // delegatecall returns 0 on error.\n', '            case 0 { revert(0, returndatasize) }\n', '            default { return(0, returndatasize) }\n', '        }\n', '    }\n', '\n', '    /**\n', '     * @dev Function that is run as the first thing in the fallback function.\n', '     * Can be redefined in derived contracts to add functionality.\n', '     * Redefinitions must call super._willFallback().\n', '     */\n', '    function _willFallback() internal {\n', '    }\n', '\n', '    /**\n', '     * @dev fallback implementation.\n', '     * Extracted to enable manual triggering.\n', '     */\n', '    function _fallback() internal {\n', '        _willFallback();\n', '        _delegate(_implementation());\n', '    }\n', '}\n', '\n', '// File: contracts/TokenUnlockProxy.sol\n', '\n', 'pragma solidity ^0.5.16;\n', '\n', '\n', '\n', 'contract TokenUnlockProxy is Proxy,TokenUnlockData {\n', '\n', '    event Upgraded(address indexed implementation);\n', '\n', '    constructor(address _implAddress,address _phxAddress,address _multiSignature)\n', '        multiSignatureClient(_multiSignature)\n', '        public\n', '    {\n', '        phxAddress = _phxAddress;\n', '        _setImplementation(_implAddress);\n', '    }\n', '\n', '\n', '\n', '    /**\n', '     * @dev Storage slot with the address of the current implementation.\n', '     * This is the keccak-256 hash of "org.zeppelinos.proxy.implementation", and is\n', '     * validated in the constructor.\n', '     */\n', '    bytes32 internal constant IMPLEMENTATION_SLOT = keccak256("org.Phoenix.implementation.unlocksc");\n', '\n', '    function proxyType() public pure returns (uint256){\n', '        return 2;\n', '    }\n', '\n', '    function implementation() public view returns (address) {\n', '        return _implementation();\n', '    }\n', '    /**\n', '     * @dev Returns the current implementation.\n', '     * @return Address of the current implementation\n', '     */\n', '    function _implementation() internal view returns (address impl) {\n', '        bytes32 slot = IMPLEMENTATION_SLOT;\n', '        assembly {\n', '            impl := sload(slot)\n', '        }\n', '    }\n', '\n', '    /**\n', '     * @dev Upgrades the proxy to a new implementation.\n', '     * @param newImplementation Address of the new implementation.\n', '     */\n', '    function _upgradeTo(address newImplementation)  public onlyOperator(0) validCall{\n', '        _setImplementation(newImplementation);\n', '        emit Upgraded(newImplementation);\n', '    }\n', '\n', '    /**\n', '     * @dev Sets the implementation address of the proxy.\n', '     * @param newImplementation Address of the new implementation.\n', '     */\n', '    function _setImplementation(address newImplementation) internal {\n', '        require(ZOSLibAddress.isContract(newImplementation), "Cannot set a proxy implementation to a non-contract address");\n', '\n', '        bytes32 slot = IMPLEMENTATION_SLOT;\n', '\n', '        assembly {\n', '            sstore(slot, newImplementation)\n', '        }\n', '    }\n', '}']