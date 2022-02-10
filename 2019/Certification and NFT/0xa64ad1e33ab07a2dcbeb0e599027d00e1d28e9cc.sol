['pragma solidity ^0.5.3;\n', '\n', '\n', '/**\n', ' * Copyright © 2017-2019 Ramp Network sp. z o.o. All rights reserved (MIT License).\n', ' * \n', ' * Permission is hereby granted, free of charge, to any person obtaining a copy of this software\n', ' * and associated documentation files (the "Software"), to deal in the Software without restriction,\n', ' * including without limitation the rights to use, copy, modify, merge, publish, distribute,\n', ' * sublicense, and/or sell copies of the Software, and to permit persons to whom the Software\n', ' * is furnished to do so, subject to the following conditions:\n', ' * \n', ' * The above copyright notice and this permission notice shall be included in all copies\n', ' * or substantial portions of the Software.\n', ' * \n', ' * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING\n', ' * BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE\n', ' * AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,\n', ' * DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,\n', ' * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.\n', ' */\n', '\n', '\n', '/**\n', ' * Abstract class for an asset adapter -- a class handling the binary asset description,\n', ' * encapsulating the asset-specific transfer logic.\n', ' * The `assetData` bytes consist of a 2-byte (uint16) asset type, followed by asset-specific data.\n', ' * The asset type bytes must be equal to the `ASSET_TYPE` constant in each subclass.\n', ' *\n', ' * @dev Subclasses of this class are used as mixins to their respective main swap contract.\n', ' *\n', ' * @author Ramp Network sp. z o.o.\n', ' */\n', 'contract AssetAdapter {\n', '\n', '    uint16 public ASSET_TYPE;\n', '    bytes32 internal EIP712_SWAP_TYPEHASH;\n', '    bytes32 internal EIP712_ASSET_TYPEHASH;\n', '\n', '    constructor(\n', '        uint16 assetType,\n', '        bytes32 swapTypehash,\n', '        bytes32 assetTypehash\n', '    ) internal {\n', '        ASSET_TYPE = assetType;\n', '        EIP712_SWAP_TYPEHASH = swapTypehash;\n', '        EIP712_ASSET_TYPEHASH = assetTypehash;\n', '    }\n', '\n', '    /**\n', '     * Ensure the described asset is sent to the given address.\n', '     * Should revert if the transfer failed, but callers must also handle `false` being returned,\n', "     * much like ERC20's `transfer`.\n", '     */\n', '    function sendAssetTo(bytes memory assetData, address payable _to) internal returns (bool success);\n', '\n', '    /**\n', '     * Ensure the described asset is sent to the contract (check `msg.value` for ether,\n', '     * do a `transferFrom` for tokens, etc).\n', '     * Should revert if the transfer failed, but callers must also handle `false` being returned,\n', "     * much like ERC20's `transfer`.\n", '     *\n', "     * @dev subclasses that don't use ether should mark this with the `noEther` modifier, to make\n", '     * sure no ether is sent -- because, to have one consistent interface, the `create` function\n', '     * in `AbstractRampSwaps` is marked `payable`.\n', '     */\n', '    function lockAssetFrom(bytes memory assetData, address _from) internal returns (bool success);\n', '\n', '    /**\n', '     * Returns the EIP712 hash of the handled asset data struct.\n', '     * See `getAssetTypedHash` in the subclasses for asset struct type description.\n', '     */\n', '    function getAssetTypedHash(bytes memory data) internal view returns (bytes32);\n', '\n', '    /**\n', '     * Verify that the passed asset data should be handled by this adapter.\n', '     *\n', "     * @dev it's sufficient to use this only when creating a new swap -- all the other swap\n", '     * functions first check if the swap hash is valid, while a swap hash with invalid\n', "     * asset type wouldn't be created at all.\n", '     *\n', "     * @dev asset type is 2 bytes long, and it's at offset 32 in `assetData`'s memory (the first 32\n", '     * bytes are the data length). We load the word at offset 2 (it ends with the asset type bytes),\n', '     * and retrieve its last 2 bytes into a `uint16` variable.\n', '     */\n', '    modifier checkAssetType(bytes memory assetData) {\n', '        uint16 assetType;\n', '        // solium-disable-next-line security/no-inline-assembly\n', '        assembly {\n', '            assetType := and(\n', '                mload(add(assetData, 2)),\n', '                0xffff\n', '            )\n', '        }\n', '        require(assetType == ASSET_TYPE, "invalid asset type");\n', '        _;\n', '    }\n', '\n', '    modifier noEther() {\n', '        require(msg.value == 0, "this asset doesn\'t accept ether");\n', '        _;\n', '    }\n', '\n', '}\n', '\n', '\n', '/**\n', ' * @title partial ERC 20 Token interface according to official documentation:\n', ' * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md\n', ' */\n', 'interface Erc20Token {\n', '\n', '    /**\n', '     * Send `_value` of tokens from `msg.sender` to `_to`\n', '     *\n', '     * @param _to The recipient address\n', '     * @param _value The amount of tokens to be transferred\n', '     * @return Indication if the transfer was successful\n', '     */\n', '    function transfer(address _to, uint256 _value) external returns (bool success);\n', '\n', '    /**\n', "     * Approve `_spender` to withdraw from sender's account multiple times, up to `_value`\n", '     * amount. If this function is called again it overwrites the current allowance with _value.\n', '     *\n', "     * @param _spender The address allowed to operate on sender's tokens\n", '     * @param _value The amount of tokens allowed to be transferred\n', '     * @return Indication if the approval was successful\n', '     */\n', '    function approve(address _spender, uint256 _value) external returns (bool success);\n', '\n', '    /**\n', '     * Transfer tokens on behalf of `_from`, provided it was previously approved.\n', '     *\n', '     * @param _from The transfer source address (tokens owner)\n', '     * @param _to The transfer destination address\n', '     * @param _value The amount of tokens to be transferred\n', '     * @return Indication if the approval was successful\n', '     */\n', '    function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);\n', '}\n', '\n', '\n', '/**\n', ' * An adapter for handling ERC20-based token swaps.\n', ' *\n', ' * @author Ramp Network sp. z o.o.\n', ' */\n', 'contract TokenAdapter is AssetAdapter {\n', '\n', '    uint16 internal constant TOKEN_TYPE_ID = 2;\n', '    \n', '    // the hashes are generated using `genTypeHashes` from `eip712.swaps`\n', '    constructor() internal AssetAdapter(\n', '        TOKEN_TYPE_ID,\n', '        0xacdf4bfc42db1ef8f283505784fc4d04c30ee19cc3ff6ae81e0a8e522ddcc950,\n', '        0x36cb415f6a5e783824a0cf6e4d040975f6b49a9b971f3362c7a48e4ebe338f28\n', '    ) {}\n', '\n', '    /**\n', '    * @dev byte offsets, byte length & contents for token asset data:\n', '    * +00  32  uint256  data length (== 0x36 == 54 bytes)\n', '    * +32   2  uint16   asset type  (== 2)\n', '    * +34  32  uint256  token amount in units\n', '    * +66  20  address  token contract address\n', '    */\n', '    function getAmount(bytes memory assetData) internal pure returns (uint256 amount) {\n', '        // solium-disable-next-line security/no-inline-assembly\n', '        assembly {\n', '            amount := mload(add(assetData, 34))\n', '        }\n', '    }\n', '\n', '    /**\n', '     * @dev To retrieve the address at offset 66, get the word at offset 54 and return its last\n', '     * 20 bytes. See `getAmount` for byte offsets table.\n', '     */\n', '    function getTokenAddress(bytes memory assetData) internal pure returns (address tokenAddress) {\n', '        // solium-disable-next-line security/no-inline-assembly\n', '        assembly {\n', '            tokenAddress := and(\n', '                mload(add(assetData, 54)),\n', '                0xffffffffffffffffffffffffffffffffffffffff\n', '            )\n', '        }\n', '    }\n', '\n', '    function sendAssetTo(\n', '        bytes memory assetData, address payable _to\n', '    ) internal returns (bool success) {\n', '        Erc20Token token = Erc20Token(getTokenAddress(assetData));\n', '        return token.transfer(_to, getAmount(assetData));\n', '    }\n', '\n', '    function lockAssetFrom(\n', '        bytes memory assetData, address _from\n', '    ) internal noEther returns (bool success) {\n', '        Erc20Token token = Erc20Token(getTokenAddress(assetData));\n', '        return token.transferFrom(_from, address(this), getAmount(assetData));\n', '    }\n', '\n', '    /**\n', '     * Returns the EIP712 hash of the token asset data struct:\n', '     * EIP712TokenAsset {\n', '     *    amount: uint256;\n', '     *    tokenAddress: address;\n', '     * }\n', '     */\n', '    function getAssetTypedHash(bytes memory data) internal view returns (bytes32) {\n', '        return keccak256(\n', '            abi.encode(\n', '                EIP712_ASSET_TYPEHASH,\n', '                getAmount(data),\n', '                getTokenAddress(data)\n', '            )\n', '        );\n', '    }\n', '}\n', '\n', '\n', 'contract Ownable {\n', '\n', '    address public owner;\n', '\n', '    constructor() internal {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner, "only the owner can call this");\n', '        _;\n', '    }\n', '\n', '}\n', '\n', '\n', '/**\n', ' * An extended version of the standard `Pausable` contract, with more possible statuses:\n', ' *  * STOPPED: all swap actions cannot be executed until the status is changed,\n', ' *  * RETURN_ONLY: the existing swaps can only be returned, no new swaps can be created;\n', ' *  * FINALIZE_ONLY: the existing swaps can be released or returned, no new swaps can be created;\n', ' *  * ACTIVE: all swap actions can be executed.\n', ' *\n', ' * @dev the status enum is strictly monotonic, and the default 0 is mapped to STOPPED for safety.\n', ' */\n', 'contract WithStatus is Ownable {\n', '\n', '    enum Status {\n', '        STOPPED,\n', '        RETURN_ONLY,\n', '        FINALIZE_ONLY,\n', '        ACTIVE\n', '    }\n', '\n', '    event StatusChanged(Status oldStatus, Status newStatus);\n', '\n', '    Status public status = Status.ACTIVE;\n', '\n', '    constructor() internal {}\n', '\n', '    function setStatus(Status _status) external onlyOwner {\n', '        emit StatusChanged(status, _status);\n', '        status = _status;\n', '    }\n', '\n', '    modifier statusAtLeast(Status _status) {\n', '        require(status >= _status, "invalid contract status");\n', '        _;\n', '    }\n', '\n', '}\n', '\n', '\n', '/**\n', ' * An owner-managed list of oracles, that are allowed to claim, release or return swaps.\n', ' */\n', 'contract WithOracles is Ownable {\n', '\n', '    mapping (address => bool) oracles;\n', '\n', '    /**\n', '     * The deployer is the default oracle.\n', '     */\n', '    constructor() internal {\n', '        oracles[msg.sender] = true;\n', '    }\n', '\n', '    function approveOracle(address _oracle) external onlyOwner {\n', '        oracles[_oracle] = true;\n', '    }\n', '\n', '    function revokeOracle(address _oracle) external onlyOwner {\n', '        oracles[_oracle] = false;\n', '    }\n', '\n', '    modifier isOracle(address _oracle) {\n', '        require(oracles[_oracle], "invalid oracle address");\n', '        _;\n', '    }\n', '\n', '    modifier onlyOracle(address _oracle) {\n', '        require(\n', '            msg.sender == _oracle && oracles[msg.sender],\n', '            "only the oracle can call this"\n', '        );\n', '        _;\n', '    }\n', '\n', '    modifier onlyOracleOrSender(address _sender, address _oracle) {\n', '        require(\n', '            msg.sender == _sender || (msg.sender == _oracle && oracles[msg.sender]),\n', '            "only the oracle or the sender can call this"\n', '        );\n', '        _;\n', '    }\n', '\n', '    modifier onlySender(address _sender) {\n', '        require(msg.sender == _sender, "only the sender can call this");\n', '        _;\n', '    }\n', '\n', '}\n', '\n', '\n', '/**\n', ' * The main contract managing Ramp Swaps escrows lifecycle: create, claim, release and return.\n', ' * Uses an abstract AssetAdapter to carry out the transfers and handle the particular asset data.\n', ' * With a corresponding off-chain protocol allows for atomic-swap-like transfer between\n', ' * fiat currencies and crypto assets.\n', ' *\n', ' * @dev an active swap is represented by a hash of its details, mapped to its escrow expiration\n', ' * timestamp. When the swap is created, but not yet claimed, its end time is set to SWAP_UNCLAIMED.\n', ' * The hashed swap details are:\n', " *  * address sender: the swap's creator, that sells the crypto asset;\n", ' *  * address receiver: the user that buys the crypto asset, `0x0` until the swap is claimed;\n', ' *  * address oracle: address of the oracle that handles this particular swap;\n', ' *  * bytes assetData: description of the crypto asset, handled by an AssetAdapter;\n', ' *  * bytes32 paymentDetailsHash: hash of the fiat payment details: account numbers, fiat value\n', ' *    and currency, and the transfer reference (title), that can be verified off-chain.\n', ' *\n', ' * @author Ramp Network sp. z o.o.\n', ' */\n', 'contract AbstractRampSwaps is Ownable, WithStatus, WithOracles, AssetAdapter {\n', '\n', '    /// @dev contract version, defined in semver\n', '    string public constant VERSION = "0.3.1";\n', '\n', '    /// @dev used as a special swap endTime value, to denote a yet unclaimed swap\n', '    uint32 internal constant SWAP_UNCLAIMED = 1;\n', '    uint32 internal constant MIN_ACTUAL_TIMESTAMP = 1000000000;\n', '\n', "    /// @notice how long are sender's funds locked from a claim until he can cancel the swap\n", '    uint32 internal constant SWAP_LOCK_TIME_S = 3600 * 24 * 7;\n', '\n', '    event Created(bytes32 indexed swapHash);\n', '    event BuyerSet(bytes32 indexed oldSwapHash, bytes32 indexed newSwapHash);\n', '    event Claimed(bytes32 indexed oldSwapHash, bytes32 indexed newSwapHash);\n', '    event Released(bytes32 indexed swapHash);\n', '    event SenderReleased(bytes32 indexed swapHash);\n', '    event Returned(bytes32 indexed swapHash);\n', '    event SenderReturned(bytes32 indexed swapHash);\n', '\n', '    /**\n', '     * @notice Mapping from swap details hash to its end time (as a unix timestamp).\n', '     * After the end time the swap can be cancelled, and the funds will be returned to the sender.\n', '     * Value `(SWAP_UNCLAIMED)` is used to denote that a swap exists, but has not yet been claimed\n', '     * by any receiver, and can also be cancelled until that.\n', '     */\n', '    mapping (bytes32 => uint32) internal swaps;\n', '\n', '    /**\n', '     * @dev EIP712 type hash for the struct:\n', '     * EIP712Domain {\n', '     *   name: string;\n', '     *   version: string;\n', '     *   chainId: uint256;\n', '     *   verifyingContract: address;\n', '     * }\n', '     */\n', '    bytes32 internal constant EIP712_DOMAIN_TYPEHASH = 0x8b73c3c69bb8fe3d512ecc4cf759cc79239f7b179b0ffacaa9a75d522b39400f;\n', '    bytes32 internal EIP712_DOMAIN_HASH;\n', '\n', '    constructor(uint256 _chainId) internal {\n', '        EIP712_DOMAIN_HASH = keccak256(\n', '            abi.encode(\n', '                EIP712_DOMAIN_TYPEHASH,\n', '                keccak256(bytes("RampSwaps")),\n', '                keccak256(bytes(VERSION)),\n', '                _chainId,\n', '                address(this)\n', '            )\n', '        );\n', '    }\n', '\n', '    /**\n', '     * Swap creation, called by the crypto sender. Checks swap parameters and ensures the crypto\n', '     * asset is locked on this contract.\n', '     * Additionally to the swap details, this function takes params v, r, s, which is checked to be\n', '     * an ECDSA signature of the swap hash made by the oracle -- to prevent users from creating\n', '     * swaps outside Ramp Network.\n', '     *\n', '     * Emits a `Created` event with the swap hash.\n', '     */\n', '    function create(\n', '        address _oracle,\n', '        bytes calldata _assetData,\n', '        bytes32 _paymentDetailsHash,\n', '        uint8 v,\n', '        bytes32 r,\n', '        bytes32 s\n', '    )\n', '        external\n', '        payable\n', '        statusAtLeast(Status.ACTIVE)\n', '        isOracle(_oracle)\n', '        checkAssetType(_assetData)\n', '        returns\n', '        (bool success)\n', '    {\n', '        bytes32 swapHash = getSwapHash(\n', '            msg.sender, address(0), _oracle, keccak256(_assetData), _paymentDetailsHash\n', '        );\n', '        requireSwapNotExists(swapHash);\n', '        require(ecrecover(swapHash, v, r, s) == _oracle, "invalid swap oracle signature");\n', '        // Set up swap status before transfer, to avoid reentrancy attacks.\n', '        // Even if a malicious token is somehow passed to this function (despite the oracle\n', '        // signature of its details), the state of this contract is already fully updated,\n', '        // so it will behave correctly (as it would be a separate call).\n', '        swaps[swapHash] = SWAP_UNCLAIMED;\n', '        require(\n', '            lockAssetFrom(_assetData, msg.sender),\n', '            "failed to lock asset on escrow"\n', '        );\n', '        emit Created(swapHash);\n', '        return true;\n', '    }\n', '\n', '    /**\n', "     * Swap claim, called by the swap's oracle on behalf of the receiver, to confirm his interest\n", '     * in buying the crypto asset.\n', "     * Additional v, r, s parameters are checked to be the receiver's EIP712 typed data signature\n", "     * of the swap's details and a 'claim this swap' action -- which verifies the receiver's address\n", '     * and the authenthicity of his claim request. See `getClaimTypedHash` for description of the\n', '     * signed swap struct.\n', '     *\n', '     * Emits a `Claimed` event with the current swap hash and the new swap hash, updated with\n', "     * receiver's address. The current swap hash equal to the hash emitted in `create`, unless\n", '     * `setBuyer` was called in the meantime -- then the current swap hash is equal to the new\n', "     * swap hash, because the receiver's address was already set.\n", '     */\n', '    function claim(\n', '        address _sender,\n', '        address _receiver,\n', '        address _oracle,\n', '        bytes calldata _assetData,\n', '        bytes32 _paymentDetailsHash,\n', '        uint8 v,\n', '        bytes32 r,\n', '        bytes32 s\n', '    ) external statusAtLeast(Status.ACTIVE) onlyOracle(_oracle) {\n', '        // Verify claim signature\n', '        bytes32 claimTypedHash = getClaimTypedHash(\n', '            _sender,\n', '            _receiver,\n', '            _assetData,\n', '            _paymentDetailsHash\n', '        );\n', '        require(ecrecover(claimTypedHash, v, r, s) == _receiver, "invalid claim receiver signature");\n', '        // Verify swap hashes\n', '        bytes32 oldSwapHash = getSwapHash(\n', '            _sender, address(0), _oracle, keccak256(_assetData), _paymentDetailsHash\n', '        );\n', '        bytes32 newSwapHash = getSwapHash(\n', '            _sender, _receiver, _oracle, keccak256(_assetData), _paymentDetailsHash\n', '        );\n', '        bytes32 claimFromHash;\n', '        // We want this function to be universal, regardless of whether `setBuyer` was called before.\n', '        // If it was, the hash is already changed\n', '        if (swaps[oldSwapHash] == 0) {\n', '            claimFromHash = newSwapHash;\n', '            requireSwapUnclaimed(newSwapHash);\n', '        } else {\n', '            claimFromHash = oldSwapHash;\n', '            requireSwapUnclaimed(oldSwapHash);\n', '            requireSwapNotExists(newSwapHash);\n', '            swaps[oldSwapHash] = 0;\n', '        }\n', '        // any overflow security warnings can be safely ignored -- SWAP_LOCK_TIME_S is a small\n', "        // constant, so this won't overflow an uint32 until year 2106\n", '        // solium-disable-next-line security/no-block-members\n', '        swaps[newSwapHash] = uint32(block.timestamp) + SWAP_LOCK_TIME_S;\n', '        emit Claimed(claimFromHash, newSwapHash);\n', '    }\n', '\n', '    /**\n', '     * Swap release, which transfers the crypto asset to the receiver and removes the swap from\n', "     * the active swap mapping. Normally called by the swap's oracle after it confirms a matching\n", "     * wire transfer on sender's bank account. Can be also called by the sender, for example in case\n", '     * of a dispute, when the parties reach an agreement off-chain.\n', '     *\n', "     * Emits a `Released` event with the swap's hash.\n", '     */\n', '    function release(\n', '        address _sender,\n', '        address payable _receiver,\n', '        address _oracle,\n', '        bytes calldata _assetData,\n', '        bytes32 _paymentDetailsHash\n', '    ) external statusAtLeast(Status.FINALIZE_ONLY) onlyOracleOrSender(_sender, _oracle) {\n', '        bytes32 swapHash = getSwapHash(\n', '            _sender, _receiver, _oracle, keccak256(_assetData), _paymentDetailsHash\n', '        );\n', '        requireSwapClaimed(swapHash);\n', '        // Delete the swap status before transfer, to avoid reentrancy attacks.\n', '        swaps[swapHash] = 0;\n', '        require(\n', '            sendAssetTo(_assetData, _receiver),\n', '            "failed to send asset to receiver"\n', '        );\n', '        if (msg.sender == _sender) {\n', '            emit SenderReleased(swapHash);\n', '        } else {\n', '            emit Released(swapHash);\n', '        }\n', '    }\n', '\n', '    /**\n', '     * Swap return, which transfers the crypto asset back to the sender and removes the swap from\n', "     * the active swap mapping. Can be called by the sender or the swap's oracle, but only if the\n", '     * swap is not claimed, or was claimed but the escrow lock time expired.\n', '     *\n', "     * Emits a `Returned` event with the swap's hash.\n", '     */\n', '    function returnFunds(\n', '        address payable _sender,\n', '        address _receiver,\n', '        address _oracle,\n', '        bytes calldata _assetData,\n', '        bytes32 _paymentDetailsHash\n', '    ) external statusAtLeast(Status.RETURN_ONLY) onlyOracleOrSender(_sender, _oracle) {\n', '        bytes32 swapHash = getSwapHash(\n', '            _sender, _receiver, _oracle, keccak256(_assetData), _paymentDetailsHash\n', '        );\n', '        requireSwapUnclaimedOrExpired(swapHash);\n', '        // Delete the swap status before transfer, to avoid reentrancy attacks.\n', '        swaps[swapHash] = 0;\n', '        require(\n', '            sendAssetTo(_assetData, _sender),\n', '            "failed to send asset to sender"\n', '        );\n', '        if (msg.sender == _sender) {\n', '            emit SenderReturned(swapHash);\n', '        } else {\n', '            emit Returned(swapHash);\n', '        }\n', '    }\n', '\n', '    /**\n', '     * After the sender creates a swap, he can optionally call this function to restrict the swap\n', "     * to a particular receiver address. The swap can't then be claimed by any other receiver.\n", '     *\n', '     * Emits a `BuyerSet` event with the created swap hash and new swap hash, updated with\n', "     * receiver's address.\n", '     */\n', '    function setBuyer(\n', '        address _sender,\n', '        address _receiver,\n', '        address _oracle,\n', '        bytes calldata _assetData,\n', '        bytes32 _paymentDetailsHash\n', '    ) external statusAtLeast(Status.ACTIVE) onlySender(_sender) {\n', '        bytes32 assetHash = keccak256(_assetData);\n', '        bytes32 oldSwapHash = getSwapHash(\n', '            _sender, address(0), _oracle, assetHash, _paymentDetailsHash\n', '        );\n', '        requireSwapUnclaimed(oldSwapHash);\n', '        bytes32 newSwapHash = getSwapHash(\n', '            _sender, _receiver, _oracle, assetHash, _paymentDetailsHash\n', '        );\n', '        requireSwapNotExists(newSwapHash);\n', '        swaps[oldSwapHash] = 0;\n', '        swaps[newSwapHash] = SWAP_UNCLAIMED;\n', '        emit BuyerSet(oldSwapHash, newSwapHash);\n', '    }\n', '\n', '    /**\n', '     * Given all valid swap details, returns its status. To check a swap with unset buyer,\n', '     * use `0x0` as the `_receiver` address. The return can be:\n', "     * 0: the swap details are invalid, swap doesn't exist, or was already released/returned.\n", '     * 1: the swap was created, and is not claimed yet.\n', '     * >1: the swap was claimed, and the value is a timestamp indicating end of its lock time.\n', '     */\n', '    function getSwapStatus(\n', '        address _sender,\n', '        address _receiver,\n', '        address _oracle,\n', '        bytes calldata _assetData,\n', '        bytes32 _paymentDetailsHash\n', '    ) external view returns (uint32 status) {\n', '        bytes32 swapHash = getSwapHash(\n', '            _sender, _receiver, _oracle, keccak256(_assetData), _paymentDetailsHash\n', '        );\n', '        return swaps[swapHash];\n', '    }\n', '\n', '    /**\n', "     * Calculates the swap hash used to reference the swap in this contract's storage.\n", '     */\n', '    function getSwapHash(\n', '        address _sender,\n', '        address _receiver,\n', '        address _oracle,\n', '        bytes32 assetHash,\n', '        bytes32 _paymentDetailsHash\n', '    ) internal pure returns (bytes32 hash) {\n', '        return keccak256(\n', '            abi.encodePacked(\n', '                _sender, _receiver, _oracle, assetHash, _paymentDetailsHash\n', '            )\n', '        );\n', '    }\n', '\n', '    /**\n', '     * Returns the EIP712 typed hash for the struct:\n', '     * EIP712<Type>Swap {\n', '     *   action: bytes32;\n', '     *   sender: address;\n', '     *   receiver: address;\n', '     *   asset: asset data struct, see `getAssetTypedHash` in specific AssetAdapter contracts\n', '     *   paymentDetailsHash: bytes32;\n', '     * }\n', '     */\n', '    function getClaimTypedHash(\n', '        address _sender,\n', '        address _receiver,\n', '        bytes memory _assetData,\n', '        bytes32 _paymentDetailsHash\n', '    ) internal view returns(bytes32 msgHash) {\n', '        bytes32 dataHash = keccak256(\n', '            abi.encode(\n', '                EIP712_SWAP_TYPEHASH,\n', '                bytes32("claim this swap"),\n', '                _sender,\n', '                _receiver,\n', '                getAssetTypedHash(_assetData),\n', '                _paymentDetailsHash\n', '            )\n', '        );\n', '        return keccak256(abi.encodePacked(bytes2(0x1901), EIP712_DOMAIN_HASH, dataHash));\n', '    }\n', '\n', '    function requireSwapNotExists(bytes32 swapHash) internal view {\n', '        require(swaps[swapHash] == 0, "swap already exists");\n', '    }\n', '\n', '    function requireSwapUnclaimed(bytes32 swapHash) internal view {\n', '        require(swaps[swapHash] == SWAP_UNCLAIMED, "swap already claimed or invalid");\n', '    }\n', '\n', '    function requireSwapClaimed(bytes32 swapHash) internal view {\n', '        require(swaps[swapHash] > MIN_ACTUAL_TIMESTAMP, "swap unclaimed or invalid");\n', '    }\n', '\n', '    function requireSwapUnclaimedOrExpired(bytes32 swapHash) internal view {\n', '        require(\n', '            // solium-disable-next-line security/no-block-members\n', '            (swaps[swapHash] > MIN_ACTUAL_TIMESTAMP && block.timestamp > swaps[swapHash]) ||\n', '                swaps[swapHash] == SWAP_UNCLAIMED,\n', '            "swap not expired or invalid"\n', '        );\n', '    }\n', '\n', '}\n', '\n', '\n', '/**\n', ' * Ramp Swaps contract with the ERC20 token asset adapter.\n', ' *\n', ' * @author Ramp Network sp. z o.o.\n', ' */\n', 'contract TokenRampSwaps is AbstractRampSwaps, TokenAdapter {\n', '    constructor(uint256 _chainId) public AbstractRampSwaps(_chainId) {}\n', '}']