['pragma solidity ^0.5.7;\n', '\n', '\n', '// Batch transfer Ether and Wesion\n', '\n', '/**\n', ' * @title SafeMath for uint256\n', ' * @dev Unsigned math operations with safety checks that revert on error.\n', ' */\n', 'library SafeMath256 {\n', '    /**\n', '     * @dev Multiplies two unsigned integers, reverts on overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '}\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' */\n', 'contract Ownable {\n', '    address private _owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '     * @dev The Ownable constructor sets the original `owner` of the contract\n', '     * to the sender account.\n', '     */\n', '    constructor () internal {\n', '        _owner = msg.sender;\n', '    }\n', '\n', '    /**\n', '     * @return The address of the owner.\n', '     */\n', '    function owner() public view returns (address) {\n', '        return _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(msg.sender == _owner);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '     * @param newOwner The address to transfer ownership to.\n', '     */\n', '    function transferOwnership(address newOwner) external onlyOwner {\n', '        require(newOwner != address(0));\n', '        address __previousOwner = _owner;\n', '        _owner = newOwner;\n', '        emit OwnershipTransferred(__previousOwner, newOwner);\n', '    }\n', '\n', '    /**\n', '     * @dev Rescue compatible ERC20 Token\n', '     *\n', '     * @param tokenAddr ERC20 The address of the ERC20 token contract\n', '     * @param receiver The address of the receiver\n', '     * @param amount uint256\n', '     */\n', '    function rescueTokens(address tokenAddr, address receiver, uint256 amount) external onlyOwner {\n', '        IERC20 __token = IERC20(tokenAddr);\n', '        require(receiver != address(0));\n', '        uint256 __balance = __token.balanceOf(address(this));\n', '\n', '        require(__balance >= amount);\n', '        assert(__token.transfer(receiver, amount));\n', '    }\n', '}\n', '\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://eips.ethereum.org/EIPS/eip-20\n', ' */\n', 'interface IERC20{\n', '    function balanceOf(address owner) external view returns (uint256);\n', '    function transfer(address to, uint256 value) external returns (bool);\n', '    function transferFrom(address from, address to, uint256 value) external returns (bool);\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '}\n', '\n', '\n', '/**\n', ' * @title Batch Transfer Ether And Wesion\n', ' */\n', 'contract BatchTransferEtherAndWesion is Ownable{\n', '    using SafeMath256 for uint256;\n', '\n', '    IERC20 VOKEN = IERC20(0xF0921CF26f6BA21739530ccA9ba2548bB34308f1);\n', '\n', '    /**\n', '     * @dev Batch transfer both.\n', '     */\n', '    function batchTransfer(address payable[] memory accounts, uint256 etherValue, uint256 vokenValue) public payable {\n', '        uint256 __etherBalance = address(this).balance;\n', '        uint256 __vokenAllowance = VOKEN.allowance(msg.sender, address(this));\n', '\n', '        require(__etherBalance >= etherValue.mul(accounts.length));\n', '        require(__vokenAllowance >= vokenValue.mul(accounts.length));\n', '\n', '        for (uint256 i = 0; i < accounts.length; i++) {\n', '            accounts[i].transfer(etherValue);\n', '            assert(VOKEN.transferFrom(msg.sender, accounts[i], vokenValue));\n', '        }\n', '    }\n', '\n', '    /**\n', '     * @dev Batch transfer Ether.\n', '     */\n', '    function batchTtransferEther(address payable[] memory accounts, uint256 etherValue) public payable {\n', '        uint256 __etherBalance = address(this).balance;\n', '\n', '        require(__etherBalance >= etherValue.mul(accounts.length));\n', '\n', '        for (uint256 i = 0; i < accounts.length; i++) {\n', '            accounts[i].transfer(etherValue);\n', '        }\n', '    }\n', '\n', '    /**\n', '     * @dev Batch transfer Wesion.\n', '     */\n', '    function batchTransferWesion(address[] memory accounts, uint256 vokenValue) public {\n', '        uint256 __vokenAllowance = VOKEN.allowance(msg.sender, address(this));\n', '\n', '        require(__vokenAllowance >= vokenValue.mul(accounts.length));\n', '\n', '        for (uint256 i = 0; i < accounts.length; i++) {\n', '            assert(VOKEN.transferFrom(msg.sender, accounts[i], vokenValue));\n', '        }\n', '    }\n', '}']