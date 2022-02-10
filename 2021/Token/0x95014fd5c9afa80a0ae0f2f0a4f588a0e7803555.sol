['// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.8.0;\n', '\n', 'import "./ERC20.sol";\n', 'import "./ERC20Burnable.sol";\n', 'import "./ERC20Pausable.sol";\n', 'import "./ERC20Lockable.sol";\n', 'import "./AccessControlEnumerable.sol";\n', 'import "./Context.sol";\n', '\n', '/**\n', ' * @dev {ERC20} token, including:\n', ' *\n', ' *  - ability for holders to burn (destroy) their tokens\n', ' *  - a minter role that allows for token minting (creation)\n', ' *  - a pauser role that allows to stop all token transfers\n', ' *\n', ' * This contract uses {AccessControl} to lock permissioned functions using the\n', ' * different roles - head to its documentation for details.\n', ' *\n', ' * The account that deploys the contract will be granted the minter and pauser\n', ' * roles, as well as the default admin role, which will let it grant both minter\n', ' * and pauser roles to other accounts.\n', ' */\n', 'contract OasisGame is Context, AccessControlEnumerable, ERC20Burnable, ERC20Pausable, ERC20Lockable {\n', '    \n', '    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");\n', '    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");\n', '    bytes32 public constant LOCKER_ROLE = keccak256("LOCKER_ROLE");\n', '\n', '    /**\n', '     * @dev Grants `DEFAULT_ADMIN_ROLE`, `MINTER_ROLE` and `PAUSER_ROLE` to the\n', '     * account that deploys the contract.\n', '     *\n', '     * See {ERC20-constructor}.\n', '     */\n', '    constructor(string memory name, string memory symbol) ERC20(name, symbol) {\n', '        _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());\n', '\n', '        _setupRole(MINTER_ROLE, _msgSender());\n', '        _setupRole(PAUSER_ROLE, _msgSender());\n', '        _setupRole(LOCKER_ROLE, _msgSender());\n', '    }\n', '\n', '    /**\n', '     * @dev Creates `amount` new tokens for `to`.\n', '     *\n', '     * See {ERC20-_mint}.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - the caller must have the `MINTER_ROLE`.\n', '     */\n', '    function mint(address to, uint256 amount) public virtual {\n', '        require(hasRole(MINTER_ROLE, _msgSender()), "ERC20PresetMinterPauser: must have minter role to mint");\n', '        _mint(to, amount);\n', '    }\n', '\n', '    /**\n', '     * @dev Pauses all token transfers.\n', '     *\n', '     * See {ERC20Pausable} and {Pausable-_pause}.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - the caller must have the `PAUSER_ROLE`.\n', '     */\n', '    function pause() public virtual {\n', '        require(hasRole(PAUSER_ROLE, _msgSender()), "ERC20PresetMinterPauser: must have pauser role to pause");\n', '        _pause();\n', '    }\n', '\n', '    /**\n', '     * @dev Unpauses all token transfers.\n', '     *\n', '     * See {ERC20Pausable} and {Pausable-_unpause}.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - the caller must have the `PAUSER_ROLE`.\n', '     */\n', '    function unpause() public virtual {\n', '        require(hasRole(PAUSER_ROLE, _msgSender()), "ERC20PresetMinterPauser: must have pauser role to unpause");\n', '        _unpause();\n', '    }\n', '    \n', '    \n', '    /**\n', '     * @dev Freeze a account until undo.\n', '     *\n', '     * See {ERC20Lockable} and {Lockable-_lock}.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - the caller must have the `LOCKER_ROLE`.\n', '     */\n', '    function freezeAddress(address target) public virtual {\n', '        require(hasRole(LOCKER_ROLE, _msgSender()), "ERC20: must have locker role to lock");\n', '        _lock(target);\n', '    }\n', '    \n', '    \n', '    /**\n', '     * @dev Unfreeze a account.\n', '     *\n', '     * See {ERC20Lockable} and {Lockable-_unlock}.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - the caller must have the `LOCKER_ROLE`.\n', '     */\n', '    function unFreezeAddress(address target) public virtual {\n', '        require(hasRole(LOCKER_ROLE, _msgSender()), "ERC20: must have locker role to Unlock");\n', '        _unlock(target);\n', '    }\n', '\n', '    function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override(ERC20, ERC20Pausable, ERC20Lockable) {\n', '        super._beforeTokenTransfer(from, to, amount);\n', '    }\n', '}']