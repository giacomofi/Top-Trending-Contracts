['/**\n', ' *Submitted for verification at Etherscan.io on 2021-04-02\n', '*/\n', '\n', '// File: contracts/interface/TokenBarInterfaces.sol\n', '\n', 'pragma solidity 0.6.12;\n', '\n', 'contract TokenBarAdminStorage {\n', '    /**\n', '     * @notice Administrator for this contract\n', '     */\n', '    address public admin;\n', '    /**\n', '     * @notice Governance for this contract which has the right to adjust the parameters of TokenBar\n', '     */\n', '    address public governance;\n', '\n', '    /**\n', '     * @notice Active brains of TokenBar\n', '     */\n', '    address public implementation;\n', '}\n', '\n', 'contract xSHDStorage {\n', '    string public name = "ShardingBar";\n', '    string public symbol = "xSHD";\n', '    uint8 public constant decimals = 18;\n', '    uint256 public totalSupply;\n', '    mapping(address => uint256) public balanceOf;\n', '    mapping(address => mapping(address => uint256)) public allowance;\n', '}\n', '\n', 'contract ITokenBarStorge is TokenBarAdminStorage {\n', '    //lock period :60*60*24*7\n', '    uint256 public lockPeriod = 604800;\n', '    address public SHDToken;\n', '    mapping(address => mapping(address => address)) public routerMap;\n', '    address public marketRegulator;\n', '    address public weth;\n', '    mapping(address => uint256) public lockDeadline;\n', '}\n', '\n', '// File: contracts/TokenBarDelegator.sol\n', '\n', 'pragma solidity 0.6.12;\n', '\n', '\n', 'contract TokenBarDelegator is ITokenBarStorge, xSHDStorage {\n', '    event NewImplementation(\n', '        address oldImplementation,\n', '        address newImplementation\n', '    );\n', '\n', '    event NewAdmin(address oldAdmin, address newAdmin);\n', '    event NewGovernance(address oldGovernance, address newGovernance);\n', '\n', '    constructor(\n', '        address _governance,\n', '        address _SHDToken,\n', '        address _marketRegulator,\n', '        address _weth,\n', '        address implementation_\n', '    ) public {\n', '        admin = msg.sender;\n', '        governance = _governance;\n', '        _setImplementation(implementation_);\n', '        delegateTo(\n', '            implementation_,\n', '            abi.encodeWithSignature(\n', '                "initialize(address,address,address)",\n', '                _SHDToken,\n', '                _marketRegulator,\n', '                _weth\n', '            )\n', '        );\n', '    }\n', '\n', '    function _setImplementation(address implementation_) public {\n', '        require(\n', '            msg.sender == governance,\n', '            "_setImplementation: Caller must be governance"\n', '        );\n', '\n', '        address oldImplementation = implementation;\n', '        implementation = implementation_;\n', '\n', '        emit NewImplementation(oldImplementation, implementation);\n', '    }\n', '\n', '    function _setAdmin(address newAdmin) public {\n', '        require(msg.sender == admin, "UNAUTHORIZED");\n', '\n', '        address oldAdmin = admin;\n', '\n', '        admin = newAdmin;\n', '\n', '        emit NewAdmin(oldAdmin, newAdmin);\n', '    }\n', '\n', '    function _setGovernance(address newGovernance) public {\n', '        require(msg.sender == governance, "UNAUTHORIZED");\n', '\n', '        address oldGovernance = governance;\n', '\n', '        governance = newGovernance;\n', '\n', '        emit NewGovernance(oldGovernance, newGovernance);\n', '    }\n', '\n', '    function delegateTo(address callee, bytes memory data)\n', '        internal\n', '        returns (bytes memory)\n', '    {\n', '        (bool success, bytes memory returnData) = callee.delegatecall(data);\n', '        assembly {\n', '            if eq(success, 0) {\n', '                revert(add(returnData, 0x20), returndatasize())\n', '            }\n', '        }\n', '        return returnData;\n', '    }\n', '\n', '    receive() external payable {}\n', '\n', '    /**\n', '     * @notice Delegates execution to an implementation contract\n', '     * @dev It returns to the external caller whatever the implementation returns or forwards reverts\n', '    //  */\n', '    fallback() external payable {\n', '        // delegate all other functions to current implementation\n', '        (bool success, ) = implementation.delegatecall(msg.data);\n', '        assembly {\n', '            let free_mem_ptr := mload(0x40)\n', '            returndatacopy(free_mem_ptr, 0, returndatasize())\n', '            switch success\n', '                case 0 {\n', '                    revert(free_mem_ptr, returndatasize())\n', '                }\n', '                default {\n', '                    return(free_mem_ptr, returndatasize())\n', '                }\n', '        }\n', '    }\n', '}']