['/**\n', ' *Submitted for verification at Etherscan.io on 2021-02-22\n', '*/\n', '\n', '// SPDX-License-Identifier: GPL-3.0-or-later\n', '// Copyright (C) 2015, 2016, 2017 Dapphub\n', '// Adapted by Ethereum Community 2020\n', 'pragma solidity 0.7.6;\n', '\n', '\n', '\n', 'interface IERC20 {\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    function balanceOf(address account) external view returns (uint256);\n', '\n', '    function decimals() external returns (uint8);\n', '\n', '    function transfer(address recipient, uint256 amount)\n', '        external\n', '        returns (bool);\n', '\n', '    function allowance(address owner, address spender)\n', '        external\n', '        view\n', '        returns (uint256);\n', '\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '\n', '    function transferFrom(\n', '        address sender,\n', '        address recipient,\n', '        uint256 amount\n', '    ) external returns (bool);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(\n', '        address indexed owner,\n', '        address indexed spender,\n', '        uint256 value\n', '    );\n', '}\n', '\n', '\n', '\n', 'interface IERC2612 {\n', '    /**\n', "     * @dev Sets `amount` as the allowance of `spender` over `owner`'s tokens,\n", "     * given `owner`'s signed approval.\n", '     *\n', '     * IMPORTANT: The same issues {IERC20-approve} has related to transaction\n', '     * ordering also apply here.\n', '     *\n', '     * Emits an {Approval} event.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `owner` cannot be the zero address.\n', '     * - `spender` cannot be the zero address.\n', '     * - `deadline` must be a timestamp in the future.\n', '     * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`\n', '     * over the EIP712-formatted function arguments.\n', "     * - the signature must use ``owner``'s current nonce (see {nonces}).\n", '     *\n', '     * For more information on the signature format, see the\n', '     * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP\n', '     * section].\n', '     */\n', '    function permit(address owner, address spender, uint256 amount, uint256 deadline, uint8 v, bytes32 r, bytes32 s) external;\n', '\n', '    /**\n', '     * @dev Returns the current ERC2612 nonce for `owner`. This value must be\n', '     * included whenever a signature is generated for {permit}.\n', '     *\n', "     * Every successful call to {permit} increases ``owner``'s nonce by one. This\n", '     * prevents a signature from being used multiple times.\n', '     */\n', '    function nonces(address owner) external view returns (uint256);\n', '}\n', '\n', 'interface IERC3156FlashBorrower {\n', '\n', '    /**\n', '     * @dev Receive a flash loan.\n', '     * @param initiator The initiator of the loan.\n', '     * @param token The loan currency.\n', '     * @param amount The amount of tokens lent.\n', '     * @param fee The additional amount of tokens to repay.\n', '     * @param data Arbitrary data structure, intended to contain user-defined parameters.\n', '     * @return The keccak256 hash of "ERC3156FlashBorrower.onFlashLoan"\n', '     */\n', '    function onFlashLoan(\n', '        address initiator,\n', '        address token,\n', '        uint256 amount,\n', '        uint256 fee,\n', '        bytes calldata data\n', '    ) external returns (bytes32);\n', '}\n', '\n', '\n', 'interface IERC3156FlashLender {\n', '\n', '    /**\n', '     * @dev The amount of currency available to be lended.\n', '     * @param token The loan currency.\n', '     * @return The amount of `token` that can be borrowed.\n', '     */\n', '    function maxFlashLoan(\n', '        address token\n', '    ) external view returns (uint256);\n', '\n', '    /**\n', '     * @dev The fee to be charged for a given loan.\n', '     * @param token The loan currency.\n', '     * @param amount The amount of tokens lent.\n', '     * @return The amount of `token` to be charged for the loan, on top of the returned principal.\n', '     */\n', '    function flashFee(\n', '        address token,\n', '        uint256 amount\n', '    ) external view returns (uint256);\n', '\n', '    /**\n', '     * @dev Initiate a flash loan.\n', '     * @param receiver The receiver of the tokens in the loan, and the receiver of the callback.\n', '     * @param token The loan currency.\n', '     * @param amount The amount of tokens lent.\n', '     * @param data Arbitrary data structure, intended to contain user-defined parameters.\n', '     */\n', '    function flashLoan(\n', '        IERC3156FlashBorrower receiver,\n', '        address token,\n', '        uint256 amount,\n', '        bytes calldata data\n', '    ) external returns (bool);\n', '}\n', '\n', '/// @dev Wrapped Ether v10 (WETH10) is an Ether (ETH) ERC-20 wrapper. You can `deposit` ETH and obtain an WETH10 balance which can then be operated as an ERC-20 token. You can\n', '/// `withdraw` ETH from WETH10, which will then burn WETH10 token in your wallet. The amount of WETH10 token in any wallet is always identical to the\n', '/// balance of ETH deposited minus the ETH withdrawn with that specific wallet.\n', 'interface IWETH10 is IERC20, IERC2612, IERC3156FlashLender {\n', '\n', '    /// @dev Returns current amount of flash-minted WETH10 token.\n', '    function flashMinted() external view returns(uint256);\n', '\n', '    /// @dev `msg.value` of ETH sent to this contract grants caller account a matching increase in WETH10 token balance.\n', '    /// Emits {Transfer} event to reflect WETH10 token mint of `msg.value` from zero address to caller account.\n', '    function deposit() external payable;\n', '\n', '    /// @dev `msg.value` of ETH sent to this contract grants `to` account a matching increase in WETH10 token balance.\n', '    /// Emits {Transfer} event to reflect WETH10 token mint of `msg.value` from zero address to `to` account.\n', '    function depositTo(address to) external payable;\n', '\n', '    /// @dev Burn `value` WETH10 token from caller account and withdraw matching ETH to the same.\n', '    /// Emits {Transfer} event to reflect WETH10 token burn of `value` to zero address from caller account. \n', '    /// Requirements:\n', '    ///   - caller account must have at least `value` balance of WETH10 token.\n', '    function withdraw(uint256 value) external;\n', '\n', '    /// @dev Burn `value` WETH10 token from caller account and withdraw matching ETH to account (`to`).\n', '    /// Emits {Transfer} event to reflect WETH10 token burn of `value` to zero address from caller account.\n', '    /// Requirements:\n', '    ///   - caller account must have at least `value` balance of WETH10 token.\n', '    function withdrawTo(address payable to, uint256 value) external;\n', '\n', '    /// @dev Burn `value` WETH10 token from account (`from`) and withdraw matching ETH to account (`to`).\n', '    /// Emits {Approval} event to reflect reduced allowance `value` for caller account to spend from account (`from`),\n', '    /// unless allowance is set to `type(uint256).max`\n', '    /// Emits {Transfer} event to reflect WETH10 token burn of `value` to zero address from account (`from`).\n', '    /// Requirements:\n', '    ///   - `from` account must have at least `value` balance of WETH10 token.\n', '    ///   - `from` account must have approved caller to spend at least `value` of WETH10 token, unless `from` and caller are the same account.\n', '    function withdrawFrom(address from, address payable to, uint256 value) external;\n', '\n', '    /// @dev `msg.value` of ETH sent to this contract grants `to` account a matching increase in WETH10 token balance,\n', '    /// after which a call is executed to an ERC677-compliant contract with the `data` parameter.\n', '    /// Emits {Transfer} event.\n', '    /// Returns boolean value indicating whether operation succeeded.\n', '    /// For more information on *transferAndCall* format, see https://github.com/ethereum/EIPs/issues/677.\n', '    function depositToAndCall(address to, bytes calldata data) external payable returns (bool);\n', '\n', "    /// @dev Sets `value` as allowance of `spender` account over caller account's WETH10 token,\n", '    /// after which a call is executed to an ERC677-compliant contract with the `data` parameter.\n', '    /// Emits {Approval} event.\n', '    /// Returns boolean value indicating whether operation succeeded.\n', '    /// For more information on approveAndCall format, see https://github.com/ethereum/EIPs/issues/677.\n', '    function approveAndCall(address spender, uint256 value, bytes calldata data) external returns (bool);\n', '\n', "    /// @dev Moves `value` WETH10 token from caller's account to account (`to`), \n", '    /// after which a call is executed to an ERC677-compliant contract with the `data` parameter.\n', '    /// A transfer to `address(0)` triggers an ETH withdraw matching the sent WETH10 token in favor of caller.\n', '    /// Emits {Transfer} event.\n', '    /// Returns boolean value indicating whether operation succeeded.\n', '    /// Requirements:\n', '    ///   - caller account must have at least `value` WETH10 token.\n', '    /// For more information on transferAndCall format, see https://github.com/ethereum/EIPs/issues/677.\n', '    function transferAndCall(address to, uint value, bytes calldata data) external returns (bool);\n', '}\n', '\n', 'interface ITransferReceiver {\n', '    function onTokenTransfer(address, uint, bytes calldata) external returns (bool);\n', '}\n', '\n', 'interface IApprovalReceiver {\n', '    function onTokenApproval(address, uint, bytes calldata) external returns (bool);\n', '}\n', '\n', '/// @dev Wrapped Ether v10 (WETH10) is an Ether (ETH) ERC-20 wrapper. You can `deposit` ETH and obtain an WETH10 balance which can then be operated as an ERC-20 token. You can\n', '/// `withdraw` ETH from WETH10, which will then burn WETH10 token in your wallet. The amount of WETH10 token in any wallet is always identical to the\n', '/// balance of ETH deposited minus the ETH withdrawn with that specific wallet.\n', 'contract WETH10 is IWETH10 {\n', '\n', '    string public constant name = "WETH10";\n', '    string public constant symbol = "WETH10";\n', '    uint8  public override constant decimals = 18;\n', '\n', '    bytes32 public immutable CALLBACK_SUCCESS = keccak256("ERC3156FlashBorrower.onFlashLoan");\n', '    bytes32 public immutable PERMIT_TYPEHASH = keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");\n', '\n', '    /// @dev Records amount of WETH10 token owned by account.\n', '    mapping (address => uint256) public override balanceOf;\n', '\n', '    /// @dev Records current ERC2612 nonce for account. This value must be included whenever signature is generated for {permit}.\n', "    /// Every successful call to {permit} increases account's nonce by one. This prevents signature from being used multiple times.\n", '    mapping (address => uint256) public override nonces;\n', '\n', '    /// @dev Records number of WETH10 token that account (second) will be allowed to spend on behalf of another account (first) through {transferFrom}.\n', '    mapping (address => mapping (address => uint256)) public override allowance;\n', '\n', '    /// @dev Current amount of flash-minted WETH10 token.\n', '    uint256 public override flashMinted;\n', '    \n', '    /// @dev Returns the total supply of WETH10 token as the ETH held in this contract.\n', '    function totalSupply() external view override returns(uint256) {\n', '        return address(this).balance + flashMinted;\n', '    }\n', '\n', '    /// @dev Fallback, `msg.value` of ETH sent to this contract grants caller account a matching increase in WETH10 token balance.\n', '    /// Emits {Transfer} event to reflect WETH10 token mint of `msg.value` from zero address to caller account.\n', '    receive() external payable {\n', '        // _mintTo(msg.sender, msg.value);\n', '        balanceOf[msg.sender] += msg.value;\n', '        emit Transfer(address(0), msg.sender, msg.value);\n', '    }\n', '\n', '    /// @dev `msg.value` of ETH sent to this contract grants caller account a matching increase in WETH10 token balance.\n', '    /// Emits {Transfer} event to reflect WETH10 token mint of `msg.value` from zero address to caller account.\n', '    function deposit() external override payable {\n', '        // _mintTo(msg.sender, msg.value);\n', '        balanceOf[msg.sender] += msg.value;\n', '        emit Transfer(address(0), msg.sender, msg.value);\n', '    }\n', '\n', '    /// @dev `msg.value` of ETH sent to this contract grants `to` account a matching increase in WETH10 token balance.\n', '    /// Emits {Transfer} event to reflect WETH10 token mint of `msg.value` from zero address to `to` account.\n', '    function depositTo(address to) external override payable {\n', '        // _mintTo(to, msg.value);\n', '        balanceOf[to] += msg.value;\n', '        emit Transfer(address(0), to, msg.value);\n', '    }\n', '\n', '    /// @dev `msg.value` of ETH sent to this contract grants `to` account a matching increase in WETH10 token balance,\n', '    /// after which a call is executed to an ERC677-compliant contract with the `data` parameter.\n', '    /// Emits {Transfer} event.\n', '    /// Returns boolean value indicating whether operation succeeded.\n', '    /// For more information on *transferAndCall* format, see https://github.com/ethereum/EIPs/issues/677.\n', '    function depositToAndCall(address to, bytes calldata data) external override payable returns (bool success) {\n', '        // _mintTo(to, msg.value);\n', '        balanceOf[to] += msg.value;\n', '        emit Transfer(address(0), to, msg.value);\n', '\n', '        return ITransferReceiver(to).onTokenTransfer(msg.sender, msg.value, data);\n', '    }\n', '\n', '    /// @dev Return the amount of WETH10 token that can be flash-lent.\n', '    function maxFlashLoan(address token) external view override returns (uint256) {\n', "        return token == address(this) ? type(uint112).max - flashMinted : 0; // Can't underflow\n", '    }\n', '\n', '    /// @dev Return the fee (zero) for flash-lending an amount of WETH10 token.\n', '    function flashFee(address token, uint256) external view override returns (uint256) {\n', '        require(token == address(this), "WETH: flash mint only WETH10");\n', '        return 0;\n', '    }\n', '\n', '    /// @dev Flash lends `value` WETH10 token to the receiver address.\n', '    /// By the end of the transaction, `value` WETH10 token will be burned from the receiver.\n', '    /// The flash-minted WETH10 token is not backed by real ETH, but can be withdrawn as such up to the ETH balance of this contract.\n', '    /// Arbitrary data can be passed as a bytes calldata parameter.\n', '    /// Emits {Approval} event to reflect reduced allowance `value` for this contract to spend from receiver account (`receiver`),\n', '    /// unless allowance is set to `type(uint256).max`\n', '    /// Emits two {Transfer} events for minting and burning of the flash-minted amount.\n', '    /// Returns boolean value indicating whether operation succeeded.\n', '    /// Requirements:\n', '    ///   - `value` must be less or equal to type(uint112).max.\n', '    ///   - The total of all flash loans in a tx must be less or equal to type(uint112).max.\n', '    function flashLoan(IERC3156FlashBorrower receiver, address token, uint256 value, bytes calldata data) external override returns(bool) {\n', '        require(token == address(this), "WETH: flash mint only WETH10");\n', '        require(value <= type(uint112).max, "WETH: individual loan limit exceeded");\n', '        flashMinted = flashMinted + value;\n', '        require(flashMinted <= type(uint112).max, "WETH: total loan limit exceeded");\n', '        \n', '        // _mintTo(address(receiver), value);\n', '        balanceOf[address(receiver)] += value;\n', '        emit Transfer(address(0), address(receiver), value);\n', '\n', '        require(\n', '            receiver.onFlashLoan(msg.sender, address(this), value, 0, data) == CALLBACK_SUCCESS,\n', '            "WETH: flash loan failed"\n', '        );\n', '        \n', '        // _decreaseAllowance(address(receiver), address(this), value);\n', '        uint256 allowed = allowance[address(receiver)][address(this)];\n', '        if (allowed != type(uint256).max) {\n', '            require(allowed >= value, "WETH: request exceeds allowance");\n', '            uint256 reduced = allowed - value;\n', '            allowance[address(receiver)][address(this)] = reduced;\n', '            emit Approval(address(receiver), address(this), reduced);\n', '        }\n', '\n', '        // _burnFrom(address(receiver), value);\n', '        uint256 balance = balanceOf[address(receiver)];\n', '        require(balance >= value, "WETH: burn amount exceeds balance");\n', '        balanceOf[address(receiver)] = balance - value;\n', '        emit Transfer(address(receiver), address(0), value);\n', '        \n', '        flashMinted = flashMinted - value;\n', '        return true;\n', '    }\n', '\n', '    /// @dev Burn `value` WETH10 token from caller account and withdraw matching ETH to the same.\n', '    /// Emits {Transfer} event to reflect WETH10 token burn of `value` to zero address from caller account. \n', '    /// Requirements:\n', '    ///   - caller account must have at least `value` balance of WETH10 token.\n', '    function withdraw(uint256 value) external override {\n', '        // _burnFrom(msg.sender, value);\n', '        uint256 balance = balanceOf[msg.sender];\n', '        require(balance >= value, "WETH: burn amount exceeds balance");\n', '        balanceOf[msg.sender] = balance - value;\n', '        emit Transfer(msg.sender, address(0), value);\n', '\n', '        // _transferEther(msg.sender, value);        \n', '        (bool success, ) = msg.sender.call{value: value}("");\n', '        require(success, "WETH: ETH transfer failed");\n', '    }\n', '\n', '    /// @dev Burn `value` WETH10 token from caller account and withdraw matching ETH to account (`to`).\n', '    /// Emits {Transfer} event to reflect WETH10 token burn of `value` to zero address from caller account.\n', '    /// Requirements:\n', '    ///   - caller account must have at least `value` balance of WETH10 token.\n', '    function withdrawTo(address payable to, uint256 value) external override {\n', '        // _burnFrom(msg.sender, value);\n', '        uint256 balance = balanceOf[msg.sender];\n', '        require(balance >= value, "WETH: burn amount exceeds balance");\n', '        balanceOf[msg.sender] = balance - value;\n', '        emit Transfer(msg.sender, address(0), value);\n', '\n', '        // _transferEther(to, value);        \n', '        (bool success, ) = to.call{value: value}("");\n', '        require(success, "WETH: ETH transfer failed");\n', '    }\n', '\n', '    /// @dev Burn `value` WETH10 token from account (`from`) and withdraw matching ETH to account (`to`).\n', '    /// Emits {Approval} event to reflect reduced allowance `value` for caller account to spend from account (`from`),\n', '    /// unless allowance is set to `type(uint256).max`\n', '    /// Emits {Transfer} event to reflect WETH10 token burn of `value` to zero address from account (`from`).\n', '    /// Requirements:\n', '    ///   - `from` account must have at least `value` balance of WETH10 token.\n', '    ///   - `from` account must have approved caller to spend at least `value` of WETH10 token, unless `from` and caller are the same account.\n', '    function withdrawFrom(address from, address payable to, uint256 value) external override {\n', '        if (from != msg.sender) {\n', '            // _decreaseAllowance(from, msg.sender, value);\n', '            uint256 allowed = allowance[from][msg.sender];\n', '            if (allowed != type(uint256).max) {\n', '                require(allowed >= value, "WETH: request exceeds allowance");\n', '                uint256 reduced = allowed - value;\n', '                allowance[from][msg.sender] = reduced;\n', '                emit Approval(from, msg.sender, reduced);\n', '            }\n', '        }\n', '        \n', '        // _burnFrom(from, value);\n', '        uint256 balance = balanceOf[from];\n', '        require(balance >= value, "WETH: burn amount exceeds balance");\n', '        balanceOf[from] = balance - value;\n', '        emit Transfer(from, address(0), value);\n', '\n', '        // _transferEther(to, value);        \n', '        (bool success, ) = to.call{value: value}("");\n', '        require(success, "WETH: Ether transfer failed");\n', '    }\n', '\n', "    /// @dev Sets `value` as allowance of `spender` account over caller account's WETH10 token.\n", '    /// Emits {Approval} event.\n', '    /// Returns boolean value indicating whether operation succeeded.\n', '    function approve(address spender, uint256 value) external override returns (bool) {\n', '        // _approve(msg.sender, spender, value);\n', '        allowance[msg.sender][spender] = value;\n', '        emit Approval(msg.sender, spender, value);\n', '\n', '        return true;\n', '    }\n', '\n', "    /// @dev Sets `value` as allowance of `spender` account over caller account's WETH10 token,\n", '    /// after which a call is executed to an ERC677-compliant contract with the `data` parameter.\n', '    /// Emits {Approval} event.\n', '    /// Returns boolean value indicating whether operation succeeded.\n', '    /// For more information on approveAndCall format, see https://github.com/ethereum/EIPs/issues/677.\n', '    function approveAndCall(address spender, uint256 value, bytes calldata data) external override returns (bool) {\n', '        // _approve(msg.sender, spender, value);\n', '        allowance[msg.sender][spender] = value;\n', '        emit Approval(msg.sender, spender, value);\n', '        \n', '        return IApprovalReceiver(spender).onTokenApproval(msg.sender, value, data);\n', '    }\n', '\n', "    /// @dev Sets `value` as allowance of `spender` account over `owner` account's WETH10 token, given `owner` account's signed approval.\n", '    /// Emits {Approval} event.\n', '    /// Requirements:\n', '    ///   - `deadline` must be timestamp in future.\n', '    ///   - `v`, `r` and `s` must be valid `secp256k1` signature from `owner` account over EIP712-formatted function arguments.\n', "    ///   - the signature must use `owner` account's current nonce (see {nonces}).\n", '    ///   - the signer cannot be zero address and must be `owner` account.\n', '    /// For more information on signature format, see https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP section].\n', '    /// WETH10 token implementation adapted from https://github.com/albertocuestacanada/ERC20Permit/blob/master/contracts/ERC20Permit.sol.\n', '    function permit(address owner, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s) external override {\n', '        require(block.timestamp <= deadline, "WETH: Expired permit");\n', '\n', '        uint256 chainId;\n', '        assembly {chainId := chainid()}\n', '        bytes32 DOMAIN_SEPARATOR = keccak256(\n', '            abi.encode(\n', '                keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"),\n', '                keccak256(bytes(name)),\n', '                keccak256(bytes("1")),\n', '                chainId,\n', '                address(this)));\n', '\n', '        bytes32 hashStruct = keccak256(\n', '            abi.encode(\n', '                PERMIT_TYPEHASH,\n', '                owner,\n', '                spender,\n', '                value,\n', '                nonces[owner]++,\n', '                deadline));\n', '\n', '        bytes32 hash = keccak256(\n', '            abi.encodePacked(\n', '                "\\x19\\x01",\n', '                DOMAIN_SEPARATOR,\n', '                hashStruct));\n', '\n', '        address signer = ecrecover(hash, v, r, s);\n', '        require(signer != address(0) && signer == owner, "WETH: invalid permit");\n', '\n', '        // _approve(owner, spender, value);\n', '        allowance[owner][spender] = value;\n', '        emit Approval(owner, spender, value);\n', '    }\n', '\n', "    /// @dev Moves `value` WETH10 token from caller's account to account (`to`).\n", '    /// A transfer to `address(0)` triggers an ETH withdraw matching the sent WETH10 token in favor of caller.\n', '    /// Emits {Transfer} event.\n', '    /// Returns boolean value indicating whether operation succeeded.\n', '    /// Requirements:\n', '    ///   - caller account must have at least `value` WETH10 token.\n', '    function transfer(address to, uint256 value) external override returns (bool) {\n', '        // _transferFrom(msg.sender, to, value);\n', '        if (to != address(0)) { // Transfer\n', '            uint256 balance = balanceOf[msg.sender];\n', '            require(balance >= value, "WETH: transfer amount exceeds balance");\n', '\n', '            balanceOf[msg.sender] = balance - value;\n', '            balanceOf[to] += value;\n', '            emit Transfer(msg.sender, to, value);\n', '        } else { // Withdraw\n', '            uint256 balance = balanceOf[msg.sender];\n', '            require(balance >= value, "WETH: burn amount exceeds balance");\n', '            balanceOf[msg.sender] = balance - value;\n', '            emit Transfer(msg.sender, address(0), value);\n', '            \n', '            (bool success, ) = msg.sender.call{value: value}("");\n', '            require(success, "WETH: ETH transfer failed");\n', '        }\n', '        \n', '        return true;\n', '    }\n', '\n', '    /// @dev Moves `value` WETH10 token from account (`from`) to account (`to`) using allowance mechanism.\n', "    /// `value` is then deducted from caller account's allowance, unless set to `type(uint256).max`.\n", '    /// A transfer to `address(0)` triggers an ETH withdraw matching the sent WETH10 token in favor of caller.\n', '    /// Emits {Approval} event to reflect reduced allowance `value` for caller account to spend from account (`from`),\n', '    /// unless allowance is set to `type(uint256).max`\n', '    /// Emits {Transfer} event.\n', '    /// Returns boolean value indicating whether operation succeeded.\n', '    /// Requirements:\n', '    ///   - `from` account must have at least `value` balance of WETH10 token.\n', '    ///   - `from` account must have approved caller to spend at least `value` of WETH10 token, unless `from` and caller are the same account.\n', '    function transferFrom(address from, address to, uint256 value) external override returns (bool) {\n', '        if (from != msg.sender) {\n', '            // _decreaseAllowance(from, msg.sender, value);\n', '            uint256 allowed = allowance[from][msg.sender];\n', '            if (allowed != type(uint256).max) {\n', '                require(allowed >= value, "WETH: request exceeds allowance");\n', '                uint256 reduced = allowed - value;\n', '                allowance[from][msg.sender] = reduced;\n', '                emit Approval(from, msg.sender, reduced);\n', '            }\n', '        }\n', '        \n', '        // _transferFrom(from, to, value);\n', '        if (to != address(0)) { // Transfer\n', '            uint256 balance = balanceOf[from];\n', '            require(balance >= value, "WETH: transfer amount exceeds balance");\n', '\n', '            balanceOf[from] = balance - value;\n', '            balanceOf[to] += value;\n', '            emit Transfer(from, to, value);\n', '        } else { // Withdraw\n', '            uint256 balance = balanceOf[from];\n', '            require(balance >= value, "WETH: burn amount exceeds balance");\n', '            balanceOf[from] = balance - value;\n', '            emit Transfer(from, address(0), value);\n', '        \n', '            (bool success, ) = msg.sender.call{value: value}("");\n', '            require(success, "WETH: ETH transfer failed");\n', '        }\n', '        \n', '        return true;\n', '    }\n', '\n', "    /// @dev Moves `value` WETH10 token from caller's account to account (`to`), \n", '    /// after which a call is executed to an ERC677-compliant contract with the `data` parameter.\n', '    /// A transfer to `address(0)` triggers an ETH withdraw matching the sent WETH10 token in favor of caller.\n', '    /// Emits {Transfer} event.\n', '    /// Returns boolean value indicating whether operation succeeded.\n', '    /// Requirements:\n', '    ///   - caller account must have at least `value` WETH10 token.\n', '    /// For more information on transferAndCall format, see https://github.com/ethereum/EIPs/issues/677.\n', '    function transferAndCall(address to, uint value, bytes calldata data) external override returns (bool) {\n', '        // _transferFrom(msg.sender, to, value);\n', '        if (to != address(0)) { // Transfer\n', '            uint256 balance = balanceOf[msg.sender];\n', '            require(balance >= value, "WETH: transfer amount exceeds balance");\n', '\n', '            balanceOf[msg.sender] = balance - value;\n', '            balanceOf[to] += value;\n', '            emit Transfer(msg.sender, to, value);\n', '        } else { // Withdraw\n', '            uint256 balance = balanceOf[msg.sender];\n', '            require(balance >= value, "WETH: burn amount exceeds balance");\n', '            balanceOf[msg.sender] = balance - value;\n', '            emit Transfer(msg.sender, address(0), value);\n', '        \n', '            (bool success, ) = msg.sender.call{value: value}("");\n', '            require(success, "WETH: ETH transfer failed");\n', '        }\n', '\n', '        return ITransferReceiver(to).onTokenTransfer(msg.sender, value, data);\n', '    }\n', '}']