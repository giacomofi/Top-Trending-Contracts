['pragma solidity ^0.4.18;\n', '\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '    function totalSupply() public view returns (uint256);\n', '    function balanceOf(address who) public view returns (uint256);\n', '    function transfer(address to, uint256 value) public returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '    function allowance(address owner, address spender) public view returns (uint256);\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '    function approve(address spender, uint256 value) public returns (bool);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'contract TOSERC20  is ERC20 {\n', '    function lockBalanceOf(address who) public view returns (uint256);\n', '}\n', '\n', '/**\n', ' * @title SafeERC20\n', ' * @dev Wrappers around ERC20 operations that throw on failure.\n', ' * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,\n', ' * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.\n', ' */\n', 'library SafeERC20 {\n', '    function safeTransfer(ERC20 token, address to, uint256 value) internal {\n', '        assert(token.transfer(to, value));\n', '    }\n', '\n', '    function safeTransferFrom(\n', '        ERC20 token,\n', '        address from,\n', '        address to,\n', '        uint256 value\n', '    )\n', '    internal\n', '    {\n', '        assert(token.transferFrom(from, to, value));\n', '    }\n', '\n', '    function safeApprove(ERC20 token, address spender, uint256 value) internal {\n', '        assert(token.approve(spender, value));\n', '    }\n', '}\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '/**\n', ' * @title TosTeamLockContract\n', ' * @dev TosTeamLockContract is a token holder contract that will allow a\n', ' * beneficiary to extract the tokens after a given unlock time\n', ' */\n', 'contract TosTeamLockContract {\n', '    using SafeERC20 for TOSERC20;\n', '    using SafeMath for uint;\n', '\n', '    string public constant name = "TosTeamLockContract";\n', '\n', '    uint256 public constant RELEASE_TIME                   = 1623254400;  //2021/6/10 0:0:0;\n', '\n', '    uint256 public constant RELEASE_PERIODS                = 180 days;  \n', '\n', '    TOSERC20 public tosToken = TOSERC20(0xFb5a551374B656C6e39787B1D3A03fEAb7f3a98E);\n', '    address public beneficiary = 0xA24cB9920d882e084Cc29304d1f9c80D288F8054;\n', '\n', '    uint256 public numOfReleased = 0;\n', '\n', '\n', '    function TosTeamLockContract() public {}\n', '\n', '    /**\n', '     * @notice Transfers tokens held by timelock to beneficiary.\n', '     */\n', '    function release() public {\n', '        // solium-disable-next-line security/no-block-members\n', '        require(now >= RELEASE_TIME);\n', '\n', '        uint256 num = (now - RELEASE_TIME) / RELEASE_PERIODS;\n', '        require(num + 1 > numOfReleased);\n', '\n', '        uint256 amount = tosToken.balanceOf(this).mul(30).div(100);\n', '\n', '        require(amount > 0);\n', '\n', '        tosToken.safeTransfer(beneficiary, amount);\n', '        numOfReleased = numOfReleased.add(1);   \n', '    }\n', '}']