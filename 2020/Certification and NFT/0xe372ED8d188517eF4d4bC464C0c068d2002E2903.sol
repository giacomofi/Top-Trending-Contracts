['pragma solidity ^0.6.0;\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that revert\n', ' */\n', 'library SafeMathWithRequire {\n', '    /**\n', '     * @dev Multiplies two numbers, throws on overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', "        // Gas optimization: this is cheaper than asserting 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        c = a * b;\n', '        require(c / a == b, "overflow");\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Integer division of two numbers, truncating the quotient.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b != 0, "divbyzero");\n', '        // uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '        return a / b;\n', '    }\n', '\n', '    /**\n', '     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b <= a, "undeflow");\n', '        return a - b;\n', '    }\n', '\n', '    /**\n', '     * @dev Adds two numbers, throws on overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        c = a + b;\n', '        require(c >= a, "overflow");\n', '        return c;\n', '    }\n', '}\n']
['/* solhint-disable not-rely-on-time, func-order */\n', 'pragma solidity 0.6.5;\n', '\n', 'import "../contracts_common/src/Libraries/SigUtil.sol";\n', 'import "../contracts_common/src/Libraries/SafeMathWithRequire.sol";\n', 'import "../contracts_common/src/Interfaces/ERC20.sol";\n', 'import "../contracts_common/src/BaseWithStorage/Admin.sol";\n', '\n', '\n', '/// @dev This contract verifies if a referral is valid\n', 'contract ReferralValidator is Admin {\n', '    address private _signingWallet;\n', '    uint256 private _maxCommissionRate;\n', '\n', '    mapping(address => uint256) private _previousSigningWallets;\n', '    uint256 private _previousSigningDelay = 60 * 60 * 24 * 10;\n', '\n', '    event ReferralUsed(\n', '        address indexed referrer,\n', '        address indexed referee,\n', '        address indexed token,\n', '        uint256 amount,\n', '        uint256 commission,\n', '        uint256 commissionRate\n', '    );\n', '\n', '    constructor(address initialSigningWallet, uint256 initialMaxCommissionRate) public {\n', '        _signingWallet = initialSigningWallet;\n', '        _maxCommissionRate = initialMaxCommissionRate;\n', '    }\n', '\n', '    /**\n', '     * @dev Update the signing wallet\n', '     * @param newSigningWallet The new address of the signing wallet\n', '     */\n', '    function updateSigningWallet(address newSigningWallet) external {\n', '        require(_admin == msg.sender, "Sender not admin");\n', '        _previousSigningWallets[_signingWallet] = now + _previousSigningDelay;\n', '        _signingWallet = newSigningWallet;\n', '    }\n', '\n', '    /**\n', '     * @dev signing wallet authorized for referral\n', '     * @return the address of the signing wallet\n', '     */\n', '    function getSigningWallet() external view returns (address) {\n', '        return _signingWallet;\n', '    }\n', '\n', '    /**\n', '     * @notice the max commision rate\n', '     * @return the maximum commision rate that a referral can give\n', '     */\n', '    function getMaxCommisionRate() external view returns (uint256) {\n', '        return _maxCommissionRate;\n', '    }\n', '\n', '    /**\n', '     * @dev Update the maximum commission rate\n', '     * @param newMaxCommissionRate The new maximum commission rate\n', '     */\n', '    function updateMaxCommissionRate(uint256 newMaxCommissionRate) external {\n', '        require(_admin == msg.sender, "Sender not admin");\n', '        _maxCommissionRate = newMaxCommissionRate;\n', '    }\n', '\n', '    function handleReferralWithETH(\n', '        uint256 amount,\n', '        bytes memory referral,\n', '        address payable destination\n', '    ) internal {\n', '        uint256 amountForDestination = amount;\n', '\n', '        if (referral.length > 0) {\n', '            (bytes memory signature, address referrer, address referee, uint256 expiryTime, uint256 commissionRate) = decodeReferral(referral);\n', '\n', '            uint256 commission = 0;\n', '\n', '            if (isReferralValid(signature, referrer, referee, expiryTime, commissionRate)) {\n', '                commission = SafeMathWithRequire.div(SafeMathWithRequire.mul(amount, commissionRate), 10000);\n', '\n', '                emit ReferralUsed(referrer, referee, address(0), amount, commission, commissionRate);\n', '                amountForDestination = SafeMathWithRequire.sub(amountForDestination, commission);\n', '            }\n', '\n', '            if (commission > 0) {\n', '                address(uint160(referrer)).transfer(commission);\n', '            }\n', '        }\n', '\n', '        destination.transfer(amountForDestination);\n', '    }\n', '\n', '    function handleReferralWithERC20(\n', '        address buyer,\n', '        uint256 amount,\n', '        bytes memory referral,\n', '        address payable destination,\n', '        address tokenAddress\n', '    ) internal {\n', '        ERC20 token = ERC20(tokenAddress);\n', '        uint256 amountForDestination = amount;\n', '\n', '        if (referral.length > 0) {\n', '            (bytes memory signature, address referrer, address referee, uint256 expiryTime, uint256 commissionRate) = decodeReferral(referral);\n', '\n', '            uint256 commission = 0;\n', '\n', '            if (isReferralValid(signature, referrer, referee, expiryTime, commissionRate)) {\n', '                commission = SafeMathWithRequire.div(SafeMathWithRequire.mul(amount, commissionRate), 10000);\n', '\n', '                emit ReferralUsed(referrer, referee, tokenAddress, amount, commission, commissionRate);\n', '                amountForDestination = SafeMathWithRequire.sub(amountForDestination, commission);\n', '            }\n', '\n', '            if (commission > 0) {\n', '                require(token.transferFrom(buyer, referrer, commission), "commision transfer failed");\n', '            }\n', '        }\n', '\n', '        require(token.transferFrom(buyer, destination, amountForDestination), "payment transfer failed");\n', '    }\n', '\n', '    /**\n', '     * @notice Check if a referral is valid\n', '     * @param signature The signature to check (signed referral)\n', '     * @param referrer The address of the referrer\n', '     * @param referee The address of the referee\n', '     * @param expiryTime The expiry time of the referral\n', '     * @param commissionRate The commissionRate of the referral\n', '     * @return True if the referral is valid\n', '     */\n', '    function isReferralValid(\n', '        bytes memory signature,\n', '        address referrer,\n', '        address referee,\n', '        uint256 expiryTime,\n', '        uint256 commissionRate\n', '    ) public view returns (bool) {\n', '        if (commissionRate > _maxCommissionRate || referrer == referee || now > expiryTime) {\n', '            return false;\n', '        }\n', '\n', '        bytes32 hashedData = keccak256(abi.encodePacked(referrer, referee, expiryTime, commissionRate));\n', '\n', '        address signer = SigUtil.recover(keccak256(abi.encodePacked("\\x19Ethereum Signed Message:\\n32", hashedData)), signature);\n', '\n', '        if (_previousSigningWallets[signer] >= now) {\n', '            return true;\n', '        }\n', '\n', '        return _signingWallet == signer;\n', '    }\n', '\n', '    function decodeReferral(bytes memory referral)\n', '        public\n', '        pure\n', '        returns (\n', '            bytes memory,\n', '            address,\n', '            address,\n', '            uint256,\n', '            uint256\n', '        )\n', '    {\n', '        (bytes memory signature, address referrer, address referee, uint256 expiryTime, uint256 commissionRate) = abi.decode(\n', '            referral,\n', '            (bytes, address, address, uint256, uint256)\n', '        );\n', '\n', '        return (signature, referrer, referee, expiryTime, commissionRate);\n', '    }\n', '}\n']
['pragma solidity 0.6.5;\n', '\n', '\n', 'interface LandToken {\n', '    function mintQuad(\n', '        address to,\n', '        uint256 size,\n', '        uint256 x,\n', '        uint256 y,\n', '        bytes calldata data\n', '    ) external;\n', '}\n']
['pragma solidity ^0.6.0;\n', '\n', '\n', '/**\n', '    @title ERC-1155 Multi Token Standard\n', '    @dev See https://eips.ethereum.org/EIPS/eip-1155\n', '    Note: The ERC-165 identifier for this interface is 0xd9b67a26.\n', ' */\n', 'interface ERC1155 {\n', '    event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);\n', '\n', '    event TransferBatch(address indexed operator, address indexed from, address indexed to, uint256[] ids, uint256[] values);\n', '\n', '    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);\n', '\n', '    event URI(string value, uint256 indexed id);\n', '\n', '    /**\n', '        @notice Transfers `value` amount of an `id` from  `from` to `to`  (with safety call).\n', '        @dev Caller must be approved to manage the tokens being transferred out of the `from` account (see "Approval" section of the standard).\n', '        MUST revert if `to` is the zero address.\n', '        MUST revert if balance of holder for token `id` is lower than the `value` sent.\n', '        MUST revert on any other error.\n', '        MUST emit the `TransferSingle` event to reflect the balance change (see "Safe Transfer Rules" section of the standard).\n', '        After the above conditions are met, this function MUST check if `to` is a smart contract (e.g. code size > 0). If so, it MUST call `onERC1155Received` on `to` and act appropriately (see "Safe Transfer Rules" section of the standard).\n', '        @param from    Source address\n', '        @param to      Target address\n', '        @param id      ID of the token type\n', '        @param value   Transfer amount\n', '        @param data    Additional data with no specified format, MUST be sent unaltered in call to `onERC1155Received` on `to`\n', '    */\n', '    function safeTransferFrom(\n', '        address from,\n', '        address to,\n', '        uint256 id,\n', '        uint256 value,\n', '        bytes calldata data\n', '    ) external;\n', '\n', '    /**\n', '        @notice Transfers `values` amount(s) of `ids` from the `from` address to the `to` address specified (with safety call).\n', '        @dev Caller must be approved to manage the tokens being transferred out of the `from` account (see "Approval" section of the standard).\n', '        MUST revert if `to` is the zero address.\n', '        MUST revert if length of `ids` is not the same as length of `values`.\n', '        MUST revert if any of the balance(s) of the holder(s) for token(s) in `ids` is lower than the respective amount(s) in `values` sent to the recipient.\n', '        MUST revert on any other error.\n', '        MUST emit `TransferSingle` or `TransferBatch` event(s) such that all the balance changes are reflected (see "Safe Transfer Rules" section of the standard).\n', '        Balance changes and events MUST follow the ordering of the arrays (_ids[0]/_values[0] before _ids[1]/_values[1], etc).\n', '        After the above conditions for the transfer(s) in the batch are met, this function MUST check if `to` is a smart contract (e.g. code size > 0). If so, it MUST call the relevant `ERC1155TokenReceiver` hook(s) on `to` and act appropriately (see "Safe Transfer Rules" section of the standard).\n', '        @param from    Source address\n', '        @param to      Target address\n', '        @param ids     IDs of each token type (order and length must match _values array)\n', '        @param values  Transfer amounts per token type (order and length must match _ids array)\n', '        @param data    Additional data with no specified format, MUST be sent unaltered in call to the `ERC1155TokenReceiver` hook(s) on `to`\n', '    */\n', '    function safeBatchTransferFrom(\n', '        address from,\n', '        address to,\n', '        uint256[] calldata ids,\n', '        uint256[] calldata values,\n', '        bytes calldata data\n', '    ) external;\n', '\n', '    /**\n', "        @notice Get the balance of an account's tokens.\n", '        @param owner  The address of the token holder\n', '        @param id     ID of the token\n', "        @return        The _owner's balance of the token type requested\n", '     */\n', '    function balanceOf(address owner, uint256 id) external view returns (uint256);\n', '\n', '    /**\n', '        @notice Get the balance of multiple account/token pairs\n', '        @param owners The addresses of the token holders\n', '        @param ids    ID of the tokens\n', "        @return        The _owner's balance of the token types requested (i.e. balance for each (owner, id) pair)\n", '     */\n', '    function balanceOfBatch(address[] calldata owners, uint256[] calldata ids) external view returns (uint256[] memory);\n', '\n', '    /**\n', '        @notice Enable or disable approval for a third party ("operator") to manage all of the caller\'s tokens.\n', '        @dev MUST emit the ApprovalForAll event on success.\n', '        @param operator  Address to add to the set of authorized operators\n', '        @param approved  True if the operator is approved, false to revoke approval\n', '    */\n', '    function setApprovalForAll(address operator, bool approved) external;\n', '\n', '    /**\n', '        @notice Queries the approval status of an operator for a given owner.\n', '        @param owner     The owner of the tokens\n', '        @param operator  Address of authorized operator\n', '        @return           True if the operator is approved, false if not\n', '    */\n', '    function isApprovedForAll(address owner, address operator) external view returns (bool);\n', '}\n']
['pragma solidity ^0.6.0;\n', '\n', '\n', 'contract Admin {\n', '    address internal _admin;\n', '\n', '    /// @dev emitted when the contract administrator is changed.\n', '    /// @param oldAdmin address of the previous administrator.\n', '    /// @param newAdmin address of the new administrator.\n', '    event AdminChanged(address oldAdmin, address newAdmin);\n', '\n', '    /// @dev gives the current administrator of this contract.\n', '    /// @return the current administrator of this contract.\n', '    function getAdmin() external view returns (address) {\n', '        return _admin;\n', '    }\n', '\n', '    /// @dev change the administrator to be `newAdmin`.\n', '    /// @param newAdmin address of the new administrator.\n', '    function changeAdmin(address newAdmin) external {\n', '        require(msg.sender == _admin, "only admin can change admin");\n', '        emit AdminChanged(_admin, newAdmin);\n', '        _admin = newAdmin;\n', '    }\n', '\n', '    modifier onlyAdmin() {\n', '        require(msg.sender == _admin, "only admin allowed");\n', '        _;\n', '    }\n', '}\n']
['pragma solidity ^0.6.0;\n', '\n', '\n', '/**\n', ' * @title Medianizer contract\n', ' * @dev From MakerDAO (https://etherscan.io/address/0x729D19f657BD0614b4985Cf1D82531c67569197B#code)\n', ' */\n', 'interface Medianizer {\n', '    function read() external view returns (bytes32);\n', '}\n']
['pragma solidity ^0.6.0;\n', '\n', '\n', '/// @dev see https://eips.ethereum.org/EIPS/eip-20\n', 'interface ERC20 {\n', '    /// @notice emitted when tokens are transfered from one address to another.\n', '    /// @param from address from which the token are transfered from (zero means tokens are minted).\n', '    /// @param to destination address which the token are transfered to (zero means tokens are burnt).\n', '    /// @param value amount of tokens transferred.\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    /// @notice emitted when owner grant transfer rights to another address\n', '    /// @param owner address allowing its token to be transferred.\n', '    /// @param spender address allowed to spend on behalf of `owner`\n', '    /// @param value amount of tokens allowed.\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '\n', '    /// @notice return the current total amount of tokens owned by all holders.\n', '    /// @return supply total number of tokens held.\n', '    function totalSupply() external view returns (uint256 supply);\n', '\n', '    /// @notice return the number of tokens held by a particular address.\n', '    /// @param who address being queried.\n', '    /// @return balance number of token held by that address.\n', '    function balanceOf(address who) external view returns (uint256 balance);\n', '\n', '    /// @notice transfer tokens to a specific address.\n', '    /// @param to destination address receiving the tokens.\n', '    /// @param value number of tokens to transfer.\n', '    /// @return success whether the transfer succeeded.\n', '    function transfer(address to, uint256 value) external returns (bool success);\n', '\n', '    /// @notice transfer tokens from one address to another.\n', '    /// @param from address tokens will be sent from.\n', '    /// @param to destination address receiving the tokens.\n', '    /// @param value number of tokens to transfer.\n', '    /// @return success whether the transfer succeeded.\n', '    function transferFrom(\n', '        address from,\n', '        address to,\n', '        uint256 value\n', '    ) external returns (bool success);\n', '\n', '    /// @notice approve an address to spend on your behalf.\n', '    /// @param spender address entitled to transfer on your behalf.\n', '    /// @param value amount allowed to be transfered.\n', '    /// @param success whether the approval succeeded.\n', '    function approve(address spender, uint256 value) external returns (bool success);\n', '\n', '    /// @notice return the current allowance for a particular owner/spender pair.\n', '    /// @param owner address allowing spender.\n', '    /// @param spender address allowed to spend.\n', '    /// @return amount number of tokens `spender` can spend on behalf of `owner`.\n', '    function allowance(address owner, address spender) external view returns (uint256 amount);\n', '}\n']
['/* solhint-disable not-rely-on-time, func-order */\n', 'pragma solidity 0.6.5;\n', '\n', 'import "../contracts_common/src/Libraries/SafeMathWithRequire.sol";\n', 'import "./LandToken.sol";\n', 'import "../contracts_common/src/Interfaces/ERC1155.sol";\n', 'import "../contracts_common/src/Interfaces/ERC20.sol";\n', 'import "../contracts_common/src/BaseWithStorage/MetaTransactionReceiver.sol";\n', 'import "../contracts_common/src/Interfaces/Medianizer.sol";\n', 'import "../ReferralValidator/ReferralValidator.sol";\n', '\n', '\n', '/**\n', ' * @title Estate Sale contract with referral that supports also DAI and ETH as payment\n', ' * @notice This contract mananges the sale of our lands as Estates\n', ' */\n', 'contract EstateSale is MetaTransactionReceiver, ReferralValidator {\n', '    using SafeMathWithRequire for uint256;\n', '\n', '    uint256 internal constant GRID_SIZE = 408; // 408 is the size of the Land\n', '    uint256 internal constant daiPrice = 14400000000000000;\n', '\n', '    ERC1155 internal immutable _asset;\n', '    LandToken internal immutable _land;\n', '    ERC20 internal immutable _sand;\n', '    Medianizer private immutable _medianizer;\n', '    ERC20 private immutable _dai;\n', '    address internal immutable _estate;\n', '\n', '    address payable internal _wallet;\n', '    uint256 internal immutable _expiryTime;\n', '    bytes32 internal immutable _merkleRoot;\n', '\n', '    bool _sandEnabled = false;\n', '    bool _etherEnabled = true;\n', '    bool _daiEnabled = false;\n', '\n', '    event LandQuadPurchased(\n', '        address indexed buyer,\n', '        address indexed to,\n', '        uint256 indexed topCornerId,\n', '        uint256 size,\n', '        uint256 price,\n', '        address token,\n', '        uint256 amountPaid\n', '    );\n', '\n', '    constructor(\n', '        address landAddress,\n', '        address sandContractAddress,\n', '        address initialMetaTx,\n', '        address admin,\n', '        address payable initialWalletAddress,\n', '        bytes32 merkleRoot,\n', '        uint256 expiryTime,\n', '        address medianizerContractAddress,\n', '        address daiTokenContractAddress,\n', '        address initialSigningWallet,\n', '        uint256 initialMaxCommissionRate,\n', '        address estate,\n', '        address asset\n', '    ) public ReferralValidator(initialSigningWallet, initialMaxCommissionRate) {\n', '        _land = LandToken(landAddress);\n', '        _sand = ERC20(sandContractAddress);\n', '        _setMetaTransactionProcessor(initialMetaTx, true);\n', '        _wallet = initialWalletAddress;\n', '        _merkleRoot = merkleRoot;\n', '        _expiryTime = expiryTime;\n', '        _medianizer = Medianizer(medianizerContractAddress);\n', '        _dai = ERC20(daiTokenContractAddress);\n', '        _admin = admin;\n', '        _estate = estate;\n', '        _asset = ERC1155(asset);\n', '    }\n', '\n', '    /// @dev set the wallet receiving the proceeds\n', '    /// @param newWallet address of the new receiving wallet\n', '    function setReceivingWallet(address payable newWallet) external {\n', '        require(newWallet != address(0), "receiving wallet cannot be zero address");\n', '        require(msg.sender == _admin, "only admin can change the receiving wallet");\n', '        _wallet = newWallet;\n', '    }\n', '\n', '    /// @dev enable/disable DAI payment for Lands\n', '    /// @param enabled whether to enable or disable\n', '    function setDAIEnabled(bool enabled) external {\n', '        require(msg.sender == _admin, "only admin can enable/disable DAI");\n', '        _daiEnabled = enabled;\n', '    }\n', '\n', '    /// @notice return whether DAI payments are enabled\n', '    /// @return whether DAI payments are enabled\n', '    function isDAIEnabled() external view returns (bool) {\n', '        return _daiEnabled;\n', '    }\n', '\n', '    /// @notice enable/disable ETH payment for Lands\n', '    /// @param enabled whether to enable or disable\n', '    function setETHEnabled(bool enabled) external {\n', '        require(msg.sender == _admin, "only admin can enable/disable ETH");\n', '        _etherEnabled = enabled;\n', '    }\n', '\n', '    /// @notice return whether ETH payments are enabled\n', '    /// @return whether ETH payments are enabled\n', '    function isETHEnabled() external view returns (bool) {\n', '        return _etherEnabled;\n', '    }\n', '\n', '    /// @dev enable/disable the specific SAND payment for Lands\n', '    /// @param enabled whether to enable or disable\n', '    function setSANDEnabled(bool enabled) external {\n', '        require(msg.sender == _admin, "only admin can enable/disable SAND");\n', '        _sandEnabled = enabled;\n', '    }\n', '\n', '    /// @notice return whether the specific SAND payments are enabled\n', '    /// @return whether the specific SAND payments are enabled\n', '    function isSANDEnabled() external view returns (bool) {\n', '        return _sandEnabled;\n', '    }\n', '\n', '    function _checkValidity(\n', '        address buyer,\n', '        address reserved,\n', '        uint256 x,\n', '        uint256 y,\n', '        uint256 size,\n', '        uint256 price,\n', '        bytes32 salt,\n', '        uint256[] memory assetIds,\n', '        bytes32[] memory proof\n', '    ) internal view {\n', '        /* solium-disable-next-line security/no-block-members */\n', '        require(block.timestamp < _expiryTime, "sale is over");\n', '        require(buyer == msg.sender || _metaTransactionContracts[msg.sender], "not authorized");\n', '        require(reserved == address(0) || reserved == buyer, "cannot buy reserved Land");\n', '        bytes32 leaf = _generateLandHash(x, y, size, price, reserved, salt, assetIds);\n', '\n', '        require(_verify(proof, leaf), "Invalid land provided");\n', '    }\n', '\n', '    function _mint(\n', '        address buyer,\n', '        address to,\n', '        uint256 x,\n', '        uint256 y,\n', '        uint256 size,\n', '        uint256 price,\n', '        address token,\n', '        uint256 tokenAmount\n', '    ) internal {\n', '        if (size == 1 || _estate == address(0)) {\n', '            _land.mintQuad(to, size, x, y, "");\n', '        } else {\n', '            _land.mintQuad(_estate, size, x, y, abi.encode(to));\n', '        }\n', '        emit LandQuadPurchased(buyer, to, x + (y * GRID_SIZE), size, price, token, tokenAmount);\n', '    }\n', '\n', '    /**\n', '     * @notice buy Land with SAND using the merkle proof associated with it\n', '     * @param buyer address that perform the payment\n', '     * @param to address that will own the purchased Land\n', '     * @param reserved the reserved address (if any)\n', '     * @param x x coordinate of the Land\n', '     * @param y y coordinate of the Land\n', '     * @param size size of the pack of Land to purchase\n', '     * @param priceInSand price in SAND to purchase that Land\n', '     * @param proof merkleProof for that particular Land\n', '     */\n', '    function buyLandWithSand(\n', '        address buyer,\n', '        address to,\n', '        address reserved,\n', '        uint256 x,\n', '        uint256 y,\n', '        uint256 size,\n', '        uint256 priceInSand,\n', '        bytes32 salt,\n', '        uint256[] calldata assetIds,\n', '        bytes32[] calldata proof,\n', '        bytes calldata referral\n', '    ) external {\n', '        require(_sandEnabled, "sand payments not enabled");\n', '        _checkValidity(buyer, reserved, x, y, size, priceInSand, salt, assetIds, proof);\n', '\n', '        handleReferralWithERC20(buyer, priceInSand, referral, _wallet, address(_sand));\n', '\n', '        _mint(buyer, to, x, y, size, priceInSand, address(_sand), priceInSand);\n', '        _sendAssets(to, assetIds);\n', '    }\n', '\n', '    /**\n', '     * @notice buy Land with ETH using the merkle proof associated with it\n', '     * @param buyer address that perform the payment\n', '     * @param to address that will own the purchased Land\n', '     * @param reserved the reserved address (if any)\n', '     * @param x x coordinate of the Land\n', '     * @param y y coordinate of the Land\n', '     * @param size size of the pack of Land to purchase\n', '     * @param priceInSand price in SAND to purchase that Land\n', '     * @param proof merkleProof for that particular Land\n', '     * @param referral the referral used by the buyer\n', '     */\n', '    function buyLandWithETH(\n', '        address buyer,\n', '        address to,\n', '        address reserved,\n', '        uint256 x,\n', '        uint256 y,\n', '        uint256 size,\n', '        uint256 priceInSand,\n', '        bytes32 salt,\n', '        uint256[] calldata assetIds,\n', '        bytes32[] calldata proof,\n', '        bytes calldata referral\n', '    ) external payable {\n', '        require(_etherEnabled, "ether payments not enabled");\n', '        _checkValidity(buyer, reserved, x, y, size, priceInSand, salt, assetIds, proof);\n', '\n', '        uint256 ETHRequired = getEtherAmountWithSAND(priceInSand);\n', '        require(msg.value >= ETHRequired, "not enough ether sent");\n', '\n', '        if (msg.value - ETHRequired > 0) {\n', '            msg.sender.transfer(msg.value - ETHRequired); // refund extra\n', '        }\n', '\n', '        handleReferralWithETH(ETHRequired, referral, _wallet);\n', '\n', '        _mint(buyer, to, x, y, size, priceInSand, address(0), ETHRequired);\n', '        _sendAssets(to, assetIds);\n', '    }\n', '\n', '    /**\n', '     * @notice buy Land with DAI using the merkle proof associated with it\n', '     * @param buyer address that perform the payment\n', '     * @param to address that will own the purchased Land\n', '     * @param reserved the reserved address (if any)\n', '     * @param x x coordinate of the Land\n', '     * @param y y coordinate of the Land\n', '     * @param size size of the pack of Land to purchase\n', '     * @param priceInSand price in SAND to purchase that Land\n', '     * @param proof merkleProof for that particular Land\n', '     */\n', '    function buyLandWithDAI(\n', '        address buyer,\n', '        address to,\n', '        address reserved,\n', '        uint256 x,\n', '        uint256 y,\n', '        uint256 size,\n', '        uint256 priceInSand,\n', '        bytes32 salt,\n', '        uint256[] calldata assetIds,\n', '        bytes32[] calldata proof,\n', '        bytes calldata referral\n', '    ) external {\n', '        require(_daiEnabled, "dai payments not enabled");\n', '        _checkValidity(buyer, reserved, x, y, size, priceInSand, salt, assetIds, proof);\n', '\n', '        uint256 DAIRequired = priceInSand.mul(daiPrice).div(1000000000000000000);\n', '\n', '        handleReferralWithERC20(buyer, DAIRequired, referral, _wallet, address(_dai));\n', '\n', '        _mint(buyer, to, x, y, size, priceInSand, address(_dai), DAIRequired);\n', '        _sendAssets(to, assetIds);\n', '    }\n', '\n', '    /**\n', '     * @notice Gets the expiry time for the current sale\n', '     * @return The expiry time, as a unix epoch\n', '     */\n', '    function getExpiryTime() external view returns (uint256) {\n', '        return _expiryTime;\n', '    }\n', '\n', '    /**\n', '     * @notice Gets the Merkle root associated with the current sale\n', '     * @return The Merkle root, as a bytes32 hash\n', '     */\n', '    function merkleRoot() external view returns (bytes32) {\n', '        return _merkleRoot;\n', '    }\n', '\n', '    function _sendAssets(address to, uint256[] memory assetIds) internal {\n', '        uint256[] memory values = new uint256[](assetIds.length);\n', '        for (uint256 i = 0; i < assetIds.length; i++) {\n', '            values[i] = 1;\n', '        }\n', '        _asset.safeBatchTransferFrom(address(this), to, assetIds, values, "");\n', '    }\n', '\n', '    function _generateLandHash(\n', '        uint256 x,\n', '        uint256 y,\n', '        uint256 size,\n', '        uint256 price,\n', '        address reserved,\n', '        bytes32 salt,\n', '        uint256[] memory assetIds\n', '    ) internal pure returns (bytes32) {\n', '        return keccak256(abi.encodePacked(x, y, size, price, reserved, salt, assetIds));\n', '    }\n', '\n', '    function _verify(bytes32[] memory proof, bytes32 leaf) internal view returns (bool) {\n', '        bytes32 computedHash = leaf;\n', '\n', '        for (uint256 i = 0; i < proof.length; i++) {\n', '            bytes32 proofElement = proof[i];\n', '\n', '            if (computedHash < proofElement) {\n', '                computedHash = keccak256(abi.encodePacked(computedHash, proofElement));\n', '            } else {\n', '                computedHash = keccak256(abi.encodePacked(proofElement, computedHash));\n', '            }\n', '        }\n', '\n', '        return computedHash == _merkleRoot;\n', '    }\n', '\n', '    /**\n', '     * @notice Returns the amount of ETH for a specific amount of SAND\n', '     * @param sandAmount An amount of SAND\n', '     * @return The amount of ETH\n', '     */\n', '    function getEtherAmountWithSAND(uint256 sandAmount) public view returns (uint256) {\n', '        uint256 ethUsdPair = getEthUsdPair();\n', '        return sandAmount.mul(daiPrice).div(ethUsdPair);\n', '    }\n', '\n', '    /**\n', '     * @notice Gets the ETHUSD pair from the Medianizer contract\n', '     * @return The pair as an uint256\n', '     */\n', '    function getEthUsdPair() internal view returns (uint256) {\n', '        bytes32 pair = _medianizer.read();\n', '        return uint256(pair);\n', '    }\n', '\n', '    function onERC1155Received(\n', '        address, /*operator*/\n', '        address, /*from*/\n', '        uint256, /*id*/\n', '        uint256, /*value*/\n', '        bytes calldata /*data*/\n', '    ) external pure returns (bytes4) {\n', '        return 0xf23a6e61;\n', '    }\n', '\n', '    function onERC1155BatchReceived(\n', '        address, /*operator*/\n', '        address, /*from*/\n', '        uint256[] calldata, /*ids*/\n', '        uint256[] calldata, /*values*/\n', '        bytes calldata /*data*/\n', '    ) external pure returns (bytes4) {\n', '        return 0xbc197c81;\n', '    }\n', '\n', '    function withdrawAssets(\n', '        address to,\n', '        uint256[] calldata assetIds,\n', '        uint256[] calldata values\n', '    ) external {\n', '        require(msg.sender == _admin, "NOT_AUTHORIZED");\n', '        require(block.timestamp > _expiryTime, "SALE_NOT_OVER");\n', '        _asset.safeBatchTransferFrom(address(this), to, assetIds, values, "");\n', '    }\n', '}\n']
['pragma solidity ^0.6.0;\n', '\n', 'import "./Admin.sol";\n', '\n', '\n', 'contract MetaTransactionReceiver is Admin {\n', '    mapping(address => bool) internal _metaTransactionContracts;\n', '\n', '    /// @dev emiited when a meta transaction processor is enabled/disabled\n', '    /// @param metaTransactionProcessor address that will be given/removed metaTransactionProcessor rights.\n', '    /// @param enabled set whether the metaTransactionProcessor is enabled or disabled.\n', '    event MetaTransactionProcessor(address metaTransactionProcessor, bool enabled);\n', '\n', '    /// @dev Enable or disable the ability of `metaTransactionProcessor` to perform meta-tx (metaTransactionProcessor rights).\n', '    /// @param metaTransactionProcessor address that will be given/removed metaTransactionProcessor rights.\n', '    /// @param enabled set whether the metaTransactionProcessor is enabled or disabled.\n', '    function setMetaTransactionProcessor(address metaTransactionProcessor, bool enabled) public {\n', '        require(msg.sender == _admin, "only admin can setup metaTransactionProcessors");\n', '        _setMetaTransactionProcessor(metaTransactionProcessor, enabled);\n', '    }\n', '\n', '    function _setMetaTransactionProcessor(address metaTransactionProcessor, bool enabled) internal {\n', '        _metaTransactionContracts[metaTransactionProcessor] = enabled;\n', '        emit MetaTransactionProcessor(metaTransactionProcessor, enabled);\n', '    }\n', '\n', '    /// @dev check whether address `who` is given meta-transaction execution rights.\n', '    /// @param who The address to query.\n', '    /// @return whether the address has meta-transaction execution rights.\n', '    function isMetaTransactionProcessor(address who) external view returns (bool) {\n', '        return _metaTransactionContracts[who];\n', '    }\n', '}\n']
['pragma solidity ^0.6.0;\n', '\n', '\n', 'library SigUtil {\n', '    function recover(bytes32 hash, bytes memory sig) internal pure returns (address recovered) {\n', '        require(sig.length == 65);\n', '\n', '        bytes32 r;\n', '        bytes32 s;\n', '        uint8 v;\n', '        assembly {\n', '            r := mload(add(sig, 32))\n', '            s := mload(add(sig, 64))\n', '            v := byte(0, mload(add(sig, 96)))\n', '        }\n', '\n', '        // Version of signature should be 27 or 28, but 0 and 1 are also possible versions\n', '        if (v < 27) {\n', '            v += 27;\n', '        }\n', '        require(v == 27 || v == 28);\n', '\n', '        recovered = ecrecover(hash, v, r, s);\n', '        require(recovered != address(0));\n', '    }\n', '\n', '    function recoverWithZeroOnFailure(bytes32 hash, bytes memory sig) internal pure returns (address) {\n', '        if (sig.length != 65) {\n', '            return (address(0));\n', '        }\n', '\n', '        bytes32 r;\n', '        bytes32 s;\n', '        uint8 v;\n', '        assembly {\n', '            r := mload(add(sig, 32))\n', '            s := mload(add(sig, 64))\n', '            v := byte(0, mload(add(sig, 96)))\n', '        }\n', '\n', '        // Version of signature should be 27 or 28, but 0 and 1 are also possible versions\n', '        if (v < 27) {\n', '            v += 27;\n', '        }\n', '\n', '        if (v != 27 && v != 28) {\n', '            return (address(0));\n', '        } else {\n', '            return ecrecover(hash, v, r, s);\n', '        }\n', '    }\n', '\n', '    // Builds a prefixed hash to mimic the behavior of eth_sign.\n', '    function prefixed(bytes32 hash) internal pure returns (bytes memory) {\n', '        return abi.encodePacked("\\x19Ethereum Signed Message:\\n32", hash);\n', '    }\n', '}\n']
