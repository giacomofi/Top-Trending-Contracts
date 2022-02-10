['pragma solidity ^0.5.4;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Unsigned math operations with safety checks that revert on error\n', ' */\n', 'library SafeMath {\n', '    /**\n', '     * @dev Multiplies two unsigned integers, reverts on overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b);\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // Solidity only automatically asserts when dividing by 0\n', '        require(b > 0);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b <= a);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Adds two unsigned integers, reverts on overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a);\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),\n', '     * reverts when dividing by zero.\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b != 0);\n', '        return a % b;\n', '    }\n', '}\n', '\n', '/**\n', ' * @title SafeERC20\n', ' * @dev Wrappers around ERC20 operations that throw on failure.\n', ' * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,\n', ' * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.\n', ' */\n', 'library SafeERC20 {\n', '    using SafeMath for uint256;\n', '\n', '    function safeTransfer(IERC20 token, address to, uint256 value) internal {\n', '        require(token.transfer(to, value));\n', '    }\n', '}\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://eips.ethereum.org/EIPS/eip-20\n', ' */\n', 'interface IERC20 {\n', '    function transfer(address to, uint256 value) external returns (bool);\n', '}\n', '\n', '/**\n', ' * @title MultiBeneficiariesTokenTimelock\n', ' * @dev MultiBeneficiariesTokenTimelock is a token holder contract that will allow a\n', ' * beneficiaries to extract the tokens after a given release time\n', ' */\n', 'contract MultiBeneficiariesTokenTimelock {\n', '    using SafeERC20 for IERC20;\n', '\n', '    // ERC20 basic token contract being held\n', '    IERC20 public token;\n', '\n', '    // beneficiary of tokens after they are released\n', '    address[] public beneficiaries;\n', '    \n', '    // token amounts of beneficiaries to be released\n', '    uint256[] public tokenValues;\n', '\n', '    // timestamp when token release is enabled\n', '    uint256 public releaseTime;\n', '    \n', '    //Whether tokens have been distributed\n', '    bool public distributed;\n', '\n', '    constructor(\n', '        IERC20 _token,\n', '        address[] memory _beneficiaries,\n', '        uint256[] memory _tokenValues,\n', '        uint256 _releaseTime\n', '    )\n', '    public\n', '    {\n', '        require(_releaseTime > block.timestamp);\n', '        releaseTime = _releaseTime;\n', '        require(_beneficiaries.length == _tokenValues.length);\n', '        beneficiaries = _beneficiaries;\n', '        tokenValues = _tokenValues;\n', '        token = _token;\n', '        distributed = false;\n', '    }\n', '\n', '    /**\n', '     * @notice Transfers tokens held by timelock to beneficiaries.\n', '     */\n', '    function release() public {\n', '        require(block.timestamp >= releaseTime);\n', '        require(!distributed);\n', '\n', '        for (uint256 i = 0; i < beneficiaries.length; i++) {\n', '            address beneficiary = beneficiaries[i];\n', '            uint256 amount = tokenValues[i];\n', '            require(amount > 0);\n', '            token.safeTransfer(beneficiary, amount);\n', '        }\n', '        \n', '        distributed = true;\n', '    }\n', '    \n', '    /**\n', '     * Returns the time remaining until release\n', '     */\n', '    function getTimeLeft() public view returns (uint256 timeLeft){\n', '        if (releaseTime > block.timestamp) {\n', '            return releaseTime - block.timestamp;\n', '        }\n', '        return 0;\n', '    }\n', '    \n', '    /**\n', '     * Reject ETH \n', '     */\n', '    function() external payable {\n', '        revert();\n', '    }\n', '}']