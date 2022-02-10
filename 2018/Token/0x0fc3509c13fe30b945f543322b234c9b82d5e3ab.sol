['pragma solidity ^0.4.21;\n', '\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', '        // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', '\n', 'contract Ownable {\n', '    address public owner;\n', '\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '    /**\n', '     * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '     * account.\n', '     */\n', '    function Ownable() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '     * @param newOwner The address to transfer ownership to.\n', '     */\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        require(newOwner != address(0));\n', '        emit OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '    }\n', '\n', '}\n', '\n', 'contract ERC20 {\n', '    uint256 public totalSupply;\n', '    function balanceOf(address who) public view returns (uint256);\n', '    function transfer(address to, uint256 value) public returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    function allowance(address owner, address spender) public view returns (uint256);\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '    function approve(address spender, uint256 value) public returns (bool);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '\n', 'library SafeERC20 {\n', '    function safeTransfer(ERC20 token, address to, uint256 value) internal {\n', '        assert(token.transfer(to, value));\n', '    }\n', '\n', '    function safeTransferFrom(\n', '        ERC20 token,\n', '        address from,\n', '        address to,\n', '        uint256 value\n', '    )\n', '    internal\n', '    {\n', '        assert(token.transferFrom(from, to, value));\n', '    }\n', '\n', '    function safeApprove(ERC20 token, address spender, uint256 value) internal {\n', '        assert(token.approve(spender, value));\n', '    }\n', '}\n', '\n', '/**\n', ' * @title TokenTimelock\n', ' * @dev TokenTimelock is a token holder contract that will allow a\n', ' * beneficiary to extract the tokens after a given release time\n', ' */\n', 'contract TokenTimelock is Ownable {\n', '    using SafeERC20 for ERC20;\n', '\n', '    // ERC20 basic token contract being held\n', '    ERC20 public token;\n', '\n', '    // beneficiary of tokens after they are released\n', '    address public beneficiary;\n', '\n', '    // timestamp when token release is enabled\n', '    uint256 public releaseTime;\n', '\n', '    function TokenTimelock(ERC20 _token, address _beneficiary) public {\n', '        // solium-disable-next-line security/no-block-members\n', '        \n', '        token = _token;\n', '        beneficiary = _beneficiary;\n', '        releaseTime = now + 365 days;\n', '    }\n', '\n', '    /**\n', '     * @notice Transfers tokens held by timelock to beneficiary.\n', '     */\n', '    function release() public {\n', '        // solium-disable-next-line security/no-block-members\n', '        require(now >= releaseTime);\n', '\n', '        uint256 amount = token.balanceOf(this);\n', '        require(amount > 0);\n', '\n', '        token.safeTransfer(beneficiary, amount);\n', '    }\n', '\n', '\n', '    function setReleaseTime(uint256 _releaseTime) onlyOwner external {\n', '        require(_releaseTime > releaseTime);\n', '        releaseTime = _releaseTime;\n', '    }\n', '}']