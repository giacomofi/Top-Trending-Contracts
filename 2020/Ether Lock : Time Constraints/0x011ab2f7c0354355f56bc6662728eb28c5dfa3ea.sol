['/**\n', 'Mass Updater function that fixes a mistake on the Digester\n', '*/\n', '\n', 'pragma solidity ^0.6.12;\n', '\n', 'contract MassUpdater {\n', '    /// @notice The name of this contract\n', "    string public constant name = 'Pool Mass Updater';\n", '\n', '    /// @notice The address of the Digester, for MassUpdate the Pools.\n', '    DIGESTERInterface public digester;\n', '\n', '    constructor(address digester_) public {\n', '        digester = DIGESTERInterface(digester_);\n', '    }\n', '\n', '    function massUpdatePools() public {\n', '        uint256 length = digester.poolLength();\n', '        for (uint256 pid = 0; pid < length; ++pid) {\n', '            if (pid != 8) {\n', '                digester.updatePool(pid);\n', '            }\n', '        }\n', '    }\n', '}\n', '\n', 'interface DIGESTERInterface {\n', '    function updatePool(uint256 _pid) external;\n', '\n', '    function poolLength() external view returns (uint256);\n', '}']