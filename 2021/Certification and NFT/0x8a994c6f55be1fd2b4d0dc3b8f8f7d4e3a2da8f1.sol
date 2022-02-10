['// SPDX-License-Identifier: BSD-3-Clause\n', '\n', 'pragma solidity 0.6.11;\n', 'pragma experimental ABIEncoderV2;\n', '\n', 'import "./GovernorBravoInterfaces.sol";\n', '\n', 'contract GovernorBravoDelegator is GovernorBravoDelegatorStorage, GovernorBravoEvents {\n', '    constructor(\n', '                address timelock_,\n', '                address forth_,\n', '                address admin_,\n', '                address implementation_,\n', '                uint votingPeriod_,\n', '                uint votingDelay_,\n', '                uint proposalThreshold_) public {\n', '\n', '        // Admin set to msg.sender for initialization\n', '        admin = msg.sender;\n', '\n', '        delegateTo(implementation_, abi.encodeWithSignature("initialize(address,address,uint256,uint256,uint256)",\n', '                                                            timelock_,\n', '                                                            forth_,\n', '                                                            votingPeriod_,\n', '                                                            votingDelay_,\n', '                                                            proposalThreshold_));\n', '\n', '        _setImplementation(implementation_);\n', '\n', '        admin = admin_;\n', '    }\n', '\n', '\n', '    /**\n', '     * @notice Called by the admin to update the implementation of the delegator\n', '     * @param implementation_ The address of the new implementation for delegation\n', '     */\n', '    function _setImplementation(address implementation_) public {\n', '        require(msg.sender == admin, "GovernorBravoDelegator::_setImplementation: admin only");\n', '        require(implementation_ != address(0), "GovernorBravoDelegator::_setImplementation: invalid implementation address");\n', '\n', '        address oldImplementation = implementation;\n', '        implementation = implementation_;\n', '\n', '        emit NewImplementation(oldImplementation, implementation);\n', '    }\n', '\n', '    /**\n', '     * @notice Internal method to delegate execution to another contract\n', '     * @dev It returns to the external caller whatever the implementation returns or forwards reverts\n', '     * @param callee The contract to delegatecall\n', '     * @param data The raw data to delegatecall\n', '     */\n', '    function delegateTo(address callee, bytes memory data) internal {\n', '        (bool success, bytes memory returnData) = callee.delegatecall(data);\n', '        assembly {\n', '            if eq(success, 0) {\n', '                    revert(add(returnData, 0x20), returndatasize())\n', '            }\n', '        }\n', '    }\n', '\n', '    /**\n', '     * @dev Delegates the current call to implementation.\n', '     *\n', '     * This function does not return to its internall call site, it will return directly to the external caller.\n', '     */\n', '    function _fallback() internal {\n', '        // delegate all other functions to current implementation\n', '        (bool success, ) = implementation.delegatecall(msg.data);\n', '\n', '        assembly {\n', '            let free_mem_ptr := mload(0x40)\n', '                returndatacopy(free_mem_ptr, 0, returndatasize())\n', '\n', '                switch success\n', '                    case 0 { revert(free_mem_ptr, returndatasize()) }\n', '            default { return(free_mem_ptr, returndatasize()) }\n', '        }\n', '    }\n', '\n', '    /**\n', '     * @dev Delegates execution to an implementation contract.\n', '     * It returns to the external caller whatever the implementation returns or forwards reverts.\n', '     */\n', '    fallback() external payable {\n', '        _fallback();\n', '    }\n', '\n', '    /**\n', '     * @dev Fallback function that delegates calls to implementation. Will run if call data is empty.\n', '     */\n', '    receive() external payable {\n', '        _fallback();\n', '    }\n', '}']