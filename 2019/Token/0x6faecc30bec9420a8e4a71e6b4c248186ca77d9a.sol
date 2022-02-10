['pragma solidity ^0.5.2;\n', '\n', 'interface IERC20 {\n', '    function totalSupply() external returns (uint);\n', '    \n', '    function balanceOf(address who) external view returns (uint256);\n', '    function transfer(address to, uint256 value) external returns (bool);\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '    function transferFrom(address from, address to, uint256 value) external returns (bool);\n', '    function approve(address spender, uint256 value) external returns (bool);\n', '    \n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', 'interface IDeadTokens {\n', '    function bury(IERC20 token) external;\n', '    function buried(IERC20 token) external view returns (bool);\n', '    function callback(IERC20 token, bool valid) external;\n', '}\n', 'interface IOracle {\n', '    function test(address token) external;\n', '}\n', '\n', '\n', 'contract Cleanedapp {\n', '    IDeadTokens dt;\n', '    uint public slotsCleared;\n', '    \n', '    constructor(IDeadTokens _dt) public {\n', '        dt = _dt;\n', '    }\n', '    \n', '    modifier onlyBuried(IERC20 token) {\n', '        require(dt.buried(token), "bury token first!");\n', '        _;        \n', '    }\n', '\n', '    \n', '    event Burned(address indexed token, address indexed user, uint amount, string message);\n', '    \n', '    function burn(IERC20 token, string calldata message) external onlyBuried(token) {\n', '        _burn(token, msg.sender, message);\n', '    }\n', '    function burn(IERC20 token, address user, string calldata message) external onlyBuried(token) {\n', '        _burn(token, user, message);\n', '    }\n', '\n', '    \n', '    function _burn(IERC20 token, address user, string memory message) internal {\n', '        uint approved = token.allowance(user, address(this));\n', '        uint balance = token.balanceOf(user);\n', '        uint amount = approved < balance ? approved : balance;\n', '        \n', '        if (amount > 0) {\n', '            token.transferFrom(user, address(this), amount);\n', '            if (amount == approved) {\n', '                // this guy just sent all his tokens\n', '                slotsCleared += 1;\n', '            }\n', '            emit Burned(address(token), user, amount, message);\n', '        }\n', '    }\n', '}']