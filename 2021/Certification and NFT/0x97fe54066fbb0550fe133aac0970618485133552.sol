['pragma solidity ^0.5.16;\n', '\n', 'import "./CTokenInterfaces.sol";\n', '\n', '/**\n', " * @title Compound's CEtherDelegator Contract\n", ' * @notice CTokens which wrap Ether and delegate to an implementation\n', ' * @author Compound\n', ' */\n', 'contract CEtherDelegator is CDelegatorInterface, CTokenAdminStorage {\n', '    /**\n', '     * @notice Construct a new CEther money market\n', '     * @param comptroller_ The address of the Comptroller\n', '     * @param interestRateModel_ The address of the interest rate model\n', '     * @param initialExchangeRateMantissa_ The initial exchange rate, scaled by 1e18\n', '     * @param name_ ERC-20 name of this token\n', '     * @param symbol_ ERC-20 symbol of this token\n', '     * @param decimals_ ERC-20 decimal precision of this token\n', '     * @param admin_ Address of the administrator of this token\n', '     * @param implementation_ The address of the implementation the contract delegates to\n', '     * @param becomeImplementationData The encoded args for becomeImplementation\n', '     */\n', '    constructor(ComptrollerInterface comptroller_,\n', '                InterestRateModel interestRateModel_,\n', '                uint initialExchangeRateMantissa_,\n', '                string memory name_,\n', '                string memory symbol_,\n', '                uint8 decimals_,\n', '                address payable admin_,\n', '                address implementation_,\n', '                bytes memory becomeImplementationData,\n', '                uint256 reserveFactorMantissa_,\n', '                uint256 adminFeeMantissa_) public {\n', '        // Creator of the contract is admin during initialization\n', '        admin = msg.sender;\n', '\n', '        // First delegate gets to initialize the delegator (i.e. storage contract)\n', '        delegateTo(implementation_, abi.encodeWithSignature("initialize(address,address,uint256,string,string,uint8,uint256,uint256)",\n', '                                                            comptroller_,\n', '                                                            interestRateModel_,\n', '                                                            initialExchangeRateMantissa_,\n', '                                                            name_,\n', '                                                            symbol_,\n', '                                                            decimals_,\n', '                                                            reserveFactorMantissa_,\n', '                                                            adminFeeMantissa_));\n', '\n', '        // New implementations always get set via the settor (post-initialize)\n', '        _setImplementation(implementation_, false, becomeImplementationData);\n', '\n', '        // Set the proper admin now that initialization is done\n', '        admin = admin_;\n', '    }\n', '\n', '    /**\n', '     * @notice Called by the admin to update the implementation of the delegator\n', '     * @param implementation_ The address of the new implementation for delegation\n', '     * @param allowResign Flag to indicate whether to call _resignImplementation on the old implementation\n', '     * @param becomeImplementationData The encoded bytes data to be passed to _becomeImplementation\n', '     */\n', '    function _setImplementation(address implementation_, bool allowResign, bytes memory becomeImplementationData) public {\n', '        require(hasAdminRights(), "CErc20Delegator::_setImplementation: Caller must be admin");\n', '\n', '        if (allowResign) {\n', '            delegateToImplementation(abi.encodeWithSignature("_resignImplementation()"));\n', '        }\n', '\n', '        address oldImplementation = implementation;\n', '        implementation = implementation_;\n', '\n', '        delegateToImplementation(abi.encodeWithSignature("_becomeImplementation(bytes)", becomeImplementationData));\n', '\n', '        emit NewImplementation(oldImplementation, implementation);\n', '    }\n', '\n', '    /**\n', '     * @notice Internal method to delegate execution to another contract\n', '     * @dev It returns to the external caller whatever the implementation returns or forwards reverts\n', '     * @param callee The contract to delegatecall\n', '     * @param data The raw data to delegatecall\n', '     * @return The returned bytes from the delegatecall\n', '     */\n', '    function delegateTo(address callee, bytes memory data) internal returns (bytes memory) {\n', '        (bool success, bytes memory returnData) = callee.delegatecall(data);\n', '        assembly {\n', '            if eq(success, 0) {\n', '                revert(add(returnData, 0x20), returndatasize)\n', '            }\n', '        }\n', '        return returnData;\n', '    }\n', '\n', '    /**\n', '     * @notice Delegates execution to the implementation contract\n', '     * @dev It returns to the external caller whatever the implementation returns or forwards reverts\n', '     * @param data The raw data to delegatecall\n', '     * @return The returned bytes from the delegatecall\n', '     */\n', '    function delegateToImplementation(bytes memory data) public returns (bytes memory) {\n', '        return delegateTo(implementation, data);\n', '    }\n', '\n', '    /**\n', '     * @notice Delegates execution to an implementation contract\n', '     * @dev It returns to the external caller whatever the implementation returns or forwards reverts\n', '     */\n', '    function () external payable {\n', '        // delegate all other functions to current implementation\n', '        (bool success, ) = implementation.delegatecall(msg.data);\n', '\n', '        assembly {\n', '            let free_mem_ptr := mload(0x40)\n', '            returndatacopy(free_mem_ptr, 0, returndatasize)\n', '\n', '            switch success\n', '            case 0 { revert(free_mem_ptr, returndatasize) }\n', '            default { return(free_mem_ptr, returndatasize) }\n', '        }\n', '    }\n', '}']