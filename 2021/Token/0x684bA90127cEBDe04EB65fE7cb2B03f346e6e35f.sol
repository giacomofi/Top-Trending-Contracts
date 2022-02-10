['pragma solidity 0.7.6;\n', '\n', 'import "../../interfaces/IHypervisor.sol";\n', 'import "@openzeppelin/contracts/token/ERC20/IERC20.sol";\n', '\n', 'contract Admin {\n', '    /* user events */\n', '    event OwnerTransferPrepared(address hypervisor, address newOwner, address admin, uint256 timestamp);\n', '    event OwnerTransferFullfilled(address hypervisor, address newOwner, address admin, uint256 timestamp);\n', '\n', '    address public admin;\n', '    address public advisor;\n', '\n', '    struct OwnershipData {\n', '        address newOwner;\n', '        uint256 lastUpdatedTime;\n', '    }\n', '\n', '    mapping(address => OwnershipData) hypervisorOwner;\n', '\n', '    modifier onlyAdvisor {\n', '        require(msg.sender == advisor, "only advisor");\n', '        _;\n', '    }\n', '\n', '    modifier onlyAdmin {\n', '        require(msg.sender == admin, "only admin");\n', '        _;\n', '    }\n', '\n', '    constructor(address _admin, address _advisor) {\n', '        admin = _admin;\n', '        advisor = _advisor;\n', '    }\n', '\n', '    function rebalance(\n', '        address _hypervisor,\n', '        int24 _baseLower,\n', '        int24 _baseUpper,\n', '        int24 _limitLower,\n', '        int24 _limitUpper,\n', '        address _feeRecipient,\n', '        int256 swapQuantity\n', '    ) external onlyAdvisor {\n', '        IHypervisor(_hypervisor).rebalance(_baseLower, _baseUpper, _limitLower, _limitUpper, _feeRecipient, swapQuantity);\n', '    }\n', '\n', '    function transferAdmin(address newAdmin) external onlyAdmin {\n', '        admin = newAdmin;\n', '    }\n', '\n', '    function transferAdvisor(address newAdvisor) external onlyAdmin {\n', '        advisor = newAdvisor;\n', '    }\n', '\n', '    function prepareHVOwnertransfer(address _hypervisor, address newOwner) external onlyAdmin {\n', '        require(newOwner != address(0), "newOwner must not be zero");\n', '        hypervisorOwner[_hypervisor] = OwnershipData(newOwner, block.timestamp + 86400);\n', '        emit OwnerTransferPrepared(_hypervisor, newOwner, admin, block.timestamp);\n', '    }\n', '\n', '    function fullfillHVOwnertransfer(address _hypervisor, address newOwner) external onlyAdmin {\n', '        OwnershipData storage data = hypervisorOwner[_hypervisor];\n', '        require(data.newOwner == newOwner && data.lastUpdatedTime != 0 && data.lastUpdatedTime < block.timestamp);\n', '        IHypervisor(_hypervisor).transferOwnership(newOwner);\n', '        delete hypervisorOwner[_hypervisor];\n', '        emit OwnerTransferFullfilled(_hypervisor, newOwner, admin, block.timestamp);\n', '    }\n', '\n', '    function rescueERC20(IERC20 token, address recipient) external onlyAdmin {\n', '        require(token.transfer(recipient, token.balanceOf(address(this))));\n', '    }\n', '\n', '}\n', '\n', '// SPDX-License-Identifier: GPL-3.0-only\n', 'pragma solidity 0.7.6;\n', 'pragma abicoder v2;\n', '\n', 'import "@openzeppelin/contracts/token/ERC20/IERC20.sol";\n', '\n', 'interface IHypervisor {\n', '\n', '    /* user functions */\n', '\n', '    function rebalance(\n', '        int24 _baseLower,\n', '        int24 _baseUpper,\n', '        int24 _limitLower,\n', '        int24 _limitUpper,\n', '        address _feeRecipient,\n', '        int256 swapQuantity\n', '    ) external;\n', '\n', '    function transferOwnership(address newOwner) external;\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity >=0.6.0 <0.8.0;\n', '\n', '/**\n', ' * @dev Interface of the ERC20 standard as defined in the EIP.\n', ' */\n', 'interface IERC20 {\n', '    /**\n', '     * @dev Returns the amount of tokens in existence.\n', '     */\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    /**\n', '     * @dev Returns the amount of tokens owned by `account`.\n', '     */\n', '    function balanceOf(address account) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Moves `amount` tokens from the caller's account to `recipient`.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Returns the remaining number of tokens that `spender` will be\n', '     * allowed to spend on behalf of `owner` through {transferFrom}. This is\n', '     * zero by default.\n', '     *\n', '     * This value changes when {approve} or {transferFrom} are called.\n', '     */\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * IMPORTANT: Beware that changing an allowance with this method brings the risk\n', '     * that someone may use both the old and the new allowance by unfortunate\n', '     * transaction ordering. One possible solution to mitigate this race\n', "     * condition is to first reduce the spender's allowance to 0 and set the\n", '     * desired value afterwards:\n', '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     *\n', '     * Emits an {Approval} event.\n', '     */\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Moves `amount` tokens from `sender` to `recipient` using the\n', "     * allowance mechanism. `amount` is then deducted from the caller's\n", '     * allowance.\n', '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Emitted when `value` tokens are moved from one account (`from`) to\n', '     * another (`to`).\n', '     *\n', '     * Note that `value` may be zero.\n', '     */\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    /**\n', '     * @dev Emitted when the allowance of a `spender` for an `owner` is set by\n', '     * a call to {approve}. `value` is the new allowance.\n', '     */\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '{\n', '  "optimizer": {\n', '    "enabled": true,\n', '    "runs": 800\n', '  },\n', '  "metadata": {\n', '    "bytecodeHash": "none"\n', '  },\n', '  "outputSelection": {\n', '    "*": {\n', '      "*": [\n', '        "evm.bytecode",\n', '        "evm.deployedBytecode",\n', '        "abi"\n', '      ]\n', '    }\n', '  },\n', '  "libraries": {}\n', '}']