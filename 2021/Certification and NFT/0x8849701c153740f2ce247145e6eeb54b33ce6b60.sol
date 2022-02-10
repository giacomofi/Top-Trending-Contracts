['/**\n', ' *Submitted for verification at Etherscan.io on 2021-04-11\n', '*/\n', '\n', '/// SPDX-License-Identifier: MIT\n', '/*\n', '▄▄█    ▄   ██   █▄▄▄▄ ▄█ \n', '██     █  █ █  █  ▄▀ ██ \n', '██ ██   █ █▄▄█ █▀▀▌  ██ \n', '▐█ █ █  █ █  █ █  █  ▐█ \n', ' ▐ █  █ █    █   █    ▐ \n', '   █   ██   █   ▀   \n', '           ▀          */\n', '/// Special thanks to Keno, Boring and Gonpachi for review and inspiration.\n', 'pragma solidity 0.6.12;\n', 'pragma experimental ABIEncoderV2;\n', '\n', '// File @boringcrypto/boring-solidity/contracts/interfaces/[email\xa0protected]\n', '/// License-Identifier: MIT\n', '\n', 'interface IERC20 {\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    function balanceOf(address account) external view returns (uint256);\n', '\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '\n', '    /// @notice EIP 2612\n', '    function permit(\n', '        address owner,\n', '        address spender,\n', '        uint256 value,\n', '        uint256 deadline,\n', '        uint8 v,\n', '        bytes32 r,\n', '        bytes32 s\n', '    ) external;\n', '}\n', '\n', '/// @notice Inari registers and batches contract calls for crafty strategies.\n', 'contract Inari {\n', '    address public dao = msg.sender; // initialize governance with Inari summoner\n', '    uint public offerings; // strategies offered into Kitsune and `inari()` calls\n', '    mapping(uint => Kitsune) kitsune; // internal Kitsune mapping to `offerings`\n', '    \n', '    event MakeOffering(address indexed server, address[] to, bytes4[] sig, bytes32 descr, uint indexed offering);\n', '    event Bridge(IERC20[] token, address[] approveTo);\n', '    event Govern(address indexed dao, uint indexed kit, bool zenko);\n', '    \n', '    /// @notice Stores Inari strategies - `zenko` flagged by `dao`.\n', '    struct Kitsune {\n', '        address[] to;\n', '        bytes4[] sig;\n', '        bytes32 descr;\n', '        bool zenko;\n', '    }\n', '    \n', '    /*********\n', '    CALL INARI \n', '    *********/\n', '    /// @notice Batch Inari strategies and perform calls.\n', "    /// @param kit Kitsune strategy 'offerings' ID.\n", '    /// @param value ETH value (if any) for call.\n', '    /// @param param Parameters for call data after Kitsune `sig`.\n', '    function inari(uint[] calldata kit, uint[] calldata value, bytes[] calldata param) \n', '        external payable returns (bool success, bytes memory returnData) {\n', '        for (uint i = 0; i < kit.length; i++) {\n', '            Kitsune storage ki = kitsune[kit[i]];\n', '            (success, returnData) = ki.to[i].call{value: value[i]}\n', '            (abi.encodePacked(ki.sig[i], param[i]));\n', "            require(success, '!served');\n", '        }\n', '    }\n', '    \n', '    /// @notice Batch Inari strategies into single call with `zenko` check.\n', "    /// @param kit Kitsune strategy 'offerings' ID.\n", '    /// @param value ETH value (if any) for call.\n', '    /// @param param Parameters for call data after Kitsune `sig`.\n', '    function inariZushi(uint[] calldata kit, uint[] calldata value, bytes[] calldata param) \n', '        external payable returns (bool success, bytes memory returnData) {\n', '        for (uint i = 0; i < kit.length; i++) {\n', '            Kitsune storage ki = kitsune[kit[i]];\n', '            require(ki.zenko, "!zenko");\n', '            (success, returnData) = ki.to[i].call{value: value[i]}\n', '            (abi.encodePacked(ki.sig[i], param[i]));\n', "            require(success, '!served');\n", '        }\n', '    }\n', '    \n', '    /********\n', '    OFFERINGS \n', '    ********/\n', '    /// @notice Inspect a Kitsune offering (`kit`).\n', '    function checkOffering(uint kit) external view returns (address[] memory to, bytes4[] memory sig, string memory descr, bool zenko) {\n', '        Kitsune storage ki = kitsune[kit];\n', '        to = ki.to;\n', '        sig = ki.sig;\n', '        descr = string(abi.encodePacked(ki.descr));\n', '        zenko = ki.zenko;\n', '    }\n', '    \n', '    /// @notice Offer Kitsune strategy that can be called by `inari()`.\n', '    /// @param to The contract(s) to be called in strategy. \n', '    /// @param sig The function signature(s) involved (completed by `inari()` `param`).\n', '    function makeOffering(address[] calldata to, bytes4[] calldata sig, bytes32 descr) external { \n', '        uint kit = offerings;\n', '        kitsune[kit] = Kitsune(to, sig, descr, false);\n', '        offerings++;\n', '        emit MakeOffering(msg.sender, to, sig, descr, kit);\n', '    }\n', '    \n', '    /*********\n', '    GOVERNANCE \n', '    *********/\n', '    /// @notice Approve token for Inari to spend among contracts.\n', '    /// @param token ERC20 contract(s) to register approval for.\n', '    /// @param approveTo Spender contract(s) to pull `token` in `inari()` calls.\n', '    function bridge(IERC20[] calldata token, address[] calldata approveTo) external {\n', '        for (uint i = 0; i < token.length; i++) {\n', '            token[i].approve(approveTo[i], type(uint).max);\n', '            emit Bridge(token, approveTo);\n', '        }\n', '    }\n', '    \n', '    /// @notice Update Inari `dao` and Kitsune `zenko` status.\n', '    /// @param dao_ Address to grant Kitsune governance.\n', "    /// @param kit Kitsune strategy 'offerings' ID.\n", '    /// @param zen `kit` approval. \n', '    function govern(address dao_, uint kit, bool zen) external {\n', '        require(msg.sender == dao, "!dao");\n', '        dao = dao_;\n', '        kitsune[kit].zenko = zen;\n', '        emit Govern(dao_, kit, zen);\n', '    }\n', '}']