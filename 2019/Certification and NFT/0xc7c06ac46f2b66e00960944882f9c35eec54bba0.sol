['pragma solidity 0.5.5;\n', '\n', '\n', 'interface IERC20 {\n', '}\n', '\n', '\n', 'interface IDeadTokens {\n', '    function bury(IERC20 token) external;\n', '    function buried(IERC20 token) external view returns (bool);\n', '    function callback(IERC20 token, bool valid) external;\n', '}\n', '\n', '\n', 'interface IOracle {\n', '    function test(address token) external;\n', '}\n', '\n', 'contract DeadTokens is IDeadTokens {\n', '    mapping (address => TokenState) internal dead;\n', '    IOracle public oracle;\n', '    address internal owner;\n', '    \n', '    enum TokenState {UNKNOWN, SHIT, FAKE}\n', '    \n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    function bury(IERC20 token) external {\n', '        oracle.test(address(token));\n', '    }\n', '\n', '    function buried(IERC20 token) public view returns (bool) {\n', '        TokenState state = dead[address(token)];\n', '        \n', '        if (state == TokenState.SHIT) {\n', '            return true;\n', '        }\n', '        return false;\n', '    }\n', '    \n', '    function setOracle(IOracle _oracle) external {\n', '        require(msg.sender == owner);\n', '        oracle = _oracle;\n', '    }\n', '        \n', '    function callback(IERC20 token, bool valid) external {\n', '        require(msg.sender == address(oracle));\n', '        TokenState state = valid ? TokenState.SHIT : TokenState.FAKE;\n', '        dead[address(token)] = state;\n', '    }\n', '}']