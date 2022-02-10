['// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity 0.7.0;\n', '\n', 'interface IRegistry {\n', '    function isOwner(address _addr) external view returns (bool);\n', '\n', '    function payableOwner() external view returns (address payable);\n', '\n', '    function isInternal(address _addr) external view returns (bool);\n', '\n', '    function getLatestAddress(bytes2 _contractName)\n', '        external\n', '        view\n', '        returns (address contractAddress);\n', '}\n', '\n', 'interface IRelayer {\n', '    function onReceive(address msgSender, bytes calldata msgData)\n', '        external\n', '        payable;\n', '\n', '    function onDeposit(address msgSender) external payable;\n', '\n', '    function registrationExt(address msgSender, address referrerAddress)\n', '        external\n', '        payable;\n', '\n', '    function registration(address msgSender, address referrerAddress)\n', '        external\n', '        payable;\n', '\n', '    function occupyMatrix(\n', '        address msgSender,\n', '        uint8 matrix,\n', '        uint8 level\n', '    ) external payable;\n', '}\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '/**\n', ' * @dev Collection of functions related to the address type\n', ' */\n', 'library Address {\n', '    /**\n', '     * @dev Returns true if `account` is a contract.\n', '     *\n', '     * [IMPORTANT]\n', '     * ====\n', '     * It is unsafe to assume that an address for which this function returns\n', '     * false is an externally-owned account (EOA) and not a contract.\n', '     *\n', '     * Among others, `isContract` will return false for the following\n', '     * types of addresses:\n', '     *\n', '     *  - an externally-owned account\n', '     *  - a contract in construction\n', '     *  - an address where a contract will be created\n', '     *  - an address where a contract lived, but was destroyed\n', '     * ====\n', '     */\n', '    function isContract(address account) internal view returns (bool) {\n', '        // According to EIP-1052, 0x0 is the value returned for not-yet created accounts\n', '        // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned\n', "        // for accounts without code, i.e. `keccak256('')`\n", '        bytes32 codehash;\n', '\n', '            bytes32 accountHash\n', '         = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;\n', '        // solhint-disable-next-line no-inline-assembly\n', '        assembly {\n', '            codehash := extcodehash(account)\n', '        }\n', '        return (codehash != accountHash && codehash != 0x0);\n', '    }\n', '\n', '    /**\n', "     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to\n", '     * `recipient`, forwarding all available gas and reverting on errors.\n', '     *\n', '     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost\n', '     * of certain opcodes, possibly making contracts go over the 2300 gas limit\n', '     * imposed by `transfer`, making them unable to receive funds via\n', '     * `transfer`. {sendValue} removes this limitation.\n', '     *\n', '     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].\n', '     *\n', '     * IMPORTANT: because control is transferred to `recipient`, care must be\n', '     * taken to not create reentrancy vulnerabilities. Consider using\n', '     * {ReentrancyGuard} or the\n', '     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].\n', '     */\n', '    function sendValue(address payable recipient, uint256 amount) internal {\n', '        require(\n', '            address(this).balance >= amount,\n', '            "Address: insufficient balance"\n', '        );\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value\n', '        (bool success, ) = recipient.call{value: amount}("");\n', '        require(\n', '            success,\n', '            "Address: unable to send value, recipient may have reverted"\n', '        );\n', '    }\n', '\n', '    /**\n', '     * @dev Performs a Solidity function call using a low level `call`. A\n', '     * plain`call` is an unsafe replacement for a function call: use this\n', '     * function instead.\n', '     *\n', '     * If `target` reverts with a revert reason, it is bubbled up by this\n', '     * function (like regular Solidity function calls).\n', '     *\n', '     * Returns the raw returned data. To convert to the expected return value,\n', '     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `target` must be a contract.\n', '     * - calling `target` with `data` must not revert.\n', '     *\n', '     * _Available since v3.1._\n', '     */\n', '    function functionCall(address target, bytes memory data)\n', '        internal\n', '        returns (bytes memory)\n', '    {\n', '        return functionCall(target, data, "Address: low-level call failed");\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with\n', '     * `errorMessage` as a fallback revert reason when `target` reverts.\n', '     *\n', '     * _Available since v3.1._\n', '     */\n', '    function functionCall(\n', '        address target,\n', '        bytes memory data,\n', '        string memory errorMessage\n', '    ) internal returns (bytes memory) {\n', '        return _functionCallWithValue(target, data, 0, errorMessage);\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],\n', '     * but also transferring `value` wei to `target`.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - the calling contract must have an ETH balance of at least `value`.\n', '     * - the called Solidity function must be `payable`.\n', '     *\n', '     * _Available since v3.1._\n', '     */\n', '    function functionCallWithValue(\n', '        address target,\n', '        bytes memory data,\n', '        uint256 value\n', '    ) internal returns (bytes memory) {\n', '        return\n', '            functionCallWithValue(\n', '                target,\n', '                data,\n', '                value,\n', '                "Address: low-level call with value failed"\n', '            );\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but\n', '     * with `errorMessage` as a fallback revert reason when `target` reverts.\n', '     *\n', '     * _Available since v3.1._\n', '     */\n', '    function functionCallWithValue(\n', '        address target,\n', '        bytes memory data,\n', '        uint256 value,\n', '        string memory errorMessage\n', '    ) internal returns (bytes memory) {\n', '        require(\n', '            address(this).balance >= value,\n', '            "Address: insufficient balance for call"\n', '        );\n', '        return _functionCallWithValue(target, data, value, errorMessage);\n', '    }\n', '\n', '    function _functionCallWithValue(\n', '        address target,\n', '        bytes memory data,\n', '        uint256 weiValue,\n', '        string memory errorMessage\n', '    ) private returns (bytes memory) {\n', '        require(isContract(target), "Address: call to non-contract");\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls\n', '        (bool success, bytes memory returndata) = target.call{value: weiValue}(\n', '            data\n', '        );\n', '        if (success) {\n', '            return returndata;\n', '        } else {\n', '            // Look for revert reason and bubble it up if present\n', '            if (returndata.length > 0) {\n', '                // The easiest way to bubble the revert reason is using memory via assembly\n', '\n', '                // solhint-disable-next-line no-inline-assembly\n', '                assembly {\n', '                    let returndata_size := mload(returndata)\n', '                    revert(add(32, returndata), returndata_size)\n', '                }\n', '            } else {\n', '                revert(errorMessage);\n', '            }\n', '        }\n', '    }\n', '}\n', '\n', '\n', 'abstract contract IUpgradable {\n', '    IRegistry public registry;\n', '\n', '    modifier onlyInternal {\n', '        assert(registry.isInternal(msg.sender));\n', '        _;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        assert(registry.isOwner(msg.sender));\n', '        _;\n', '    }\n', '\n', '    modifier onlyRegistry {\n', '        assert(address(registry) == msg.sender);\n', '        _;\n', '    }\n', '\n', '    function changeDependentContractAddress() public virtual;\n', '\n', '    function changeRegistryAddress(address addr) public {\n', '        require(Address.isContract(addr), "not contract");\n', '        require(\n', '            address(registry) == address(0) || address(registry) == msg.sender,\n', '            "require registry"\n', '        );\n', '        registry = IRegistry(addr);\n', '    }\n', '}\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '/**\n', ' * @dev Contract module which allows children to implement an emergency stop\n', ' * mechanism that can be triggered by an authorized account.\n', ' *\n', ' * This module is used through inheritance. It will make available the\n', ' * modifiers `whenNotPaused` and `whenPaused`, which can be applied to\n', ' * the functions of your contract. Note that they will not be pausable by\n', ' * simply including this module, only once the modifiers are put in place.\n', ' */\n', 'contract Pausable {\n', '    /**\n', '     * @dev Emitted when the pause is triggered by `account`.\n', '     */\n', '    event Paused(address account);\n', '\n', '    /**\n', '     * @dev Emitted when the pause is lifted by `account`.\n', '     */\n', '    event Unpaused(address account);\n', '\n', '    bool private _paused;\n', '\n', '    /**\n', '     * @dev Returns true if the contract is paused, and false otherwise.\n', '     */\n', '    function paused() public view returns (bool) {\n', '        return _paused;\n', '    }\n', '\n', '    /**\n', '     * @dev Modifier to make a function callable only when the contract is not paused.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The contract must not be paused.\n', '     */\n', '    modifier whenNotPaused() {\n', '        require(!_paused, "Pausable: paused");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Modifier to make a function callable only when the contract is paused.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The contract must be paused.\n', '     */\n', '    modifier whenPaused() {\n', '        require(_paused, "Pausable: not paused");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Triggers stopped state.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The contract must not be paused.\n', '     */\n', '    function _pause() internal virtual whenNotPaused {\n', '        _paused = true;\n', '        emit Paused(msg.sender);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns to normal state.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The contract must be paused.\n', '     */\n', '    function _unpause() internal virtual whenPaused {\n', '        _paused = false;\n', '        emit Unpaused(msg.sender);\n', '    }\n', '}\n', '\n', '\n', '\n', 'contract OccupyMatrix is IUpgradable, Pausable {\n', '    IRelayer private rl;\n', '\n', '    uint8 public constant MAX_LEVEL = 13;\n', '    uint256 public lastUserId = 2;\n', '    mapping(uint256 => address) public idToAddress;\n', '    address public owner;\n', '    mapping(uint8 => uint256) public levelPrice;\n', '    mapping(address => User) public users;\n', '    struct User {\n', '        uint256 id;\n', '        address referrer;\n', '        uint256 partnersCount;\n', '        mapping(uint8 => bool) activeX3Levels;\n', '        mapping(uint8 => bool) activeX4Levels;\n', '        mapping(uint8 => X3) x3Matrix;\n', '        mapping(uint8 => X4) x4Matrix;\n', '    }\n', '\n', '    struct X3 {\n', '        address currentReferrer;\n', '        address[] referrals;\n', '        bool blocked;\n', '        uint256 reinvestCount;\n', '    }\n', '\n', '    struct X4 {\n', '        address currentReferrer;\n', '        address[] firstLevelReferrals;\n', '        address[] secondLevelReferrals;\n', '        bool blocked;\n', '        uint256 reinvestCount;\n', '        address closedPart;\n', '    }\n', '    event Registration(\n', '        address indexed user,\n', '        address indexed referrer,\n', '        uint256 indexed userId,\n', '        uint256 referrerId\n', '    );\n', '    event Reinvest(\n', '        address indexed user,\n', '        address indexed currentReferrer,\n', '        address indexed caller,\n', '        uint8 matrix,\n', '        uint8 level\n', '    );\n', '    event BuyNewLevel(\n', '        address indexed user,\n', '        address indexed referrer,\n', '        uint8 matrix,\n', '        uint8 level\n', '    );\n', '    event NewUserPlace(\n', '        address indexed user,\n', '        address indexed referrer,\n', '        uint8 matrix,\n', '        uint8 level,\n', '        uint8 place\n', '    );\n', '    event MissedEthReceive(\n', '        address indexed receiver,\n', '        address indexed from,\n', '        uint8 matrix,\n', '        uint8 level\n', '    );\n', '    event SentExtraEthDividends(\n', '        address indexed from,\n', '        address indexed receiver,\n', '        uint8 matrix,\n', '        uint8 level\n', '    );\n', '\n', '    constructor(address ownerAddress) {\n', '        levelPrice[1] = 0.02 ether;\n', '        for (uint8 i = 2; i <= MAX_LEVEL; i++) {\n', '            levelPrice[i] = levelPrice[i - 1] * 2;\n', '        }\n', '\n', '        owner = ownerAddress;\n', '\n', '        users[ownerAddress].id = 1;\n', '        idToAddress[1] = ownerAddress;\n', '\n', '        for (uint8 i = 1; i <= MAX_LEVEL; i++) {\n', '            users[ownerAddress].activeX3Levels[i] = true;\n', '            users[ownerAddress].activeX4Levels[i] = true;\n', '        }\n', '    }\n', '\n', '    fallback() external payable {\n', '        rl.onReceive{value: msg.value}(msg.sender, msg.data);\n', '    }\n', '\n', '    receive() external payable {\n', '        rl.onReceive{value: msg.value}(msg.sender, msg.data);\n', '    }\n', '\n', '    function deposit() external payable {\n', '        rl.onDeposit{value: msg.value}(msg.sender);\n', '    }\n', '\n', '    modifier checkRegisterMode(uint8 mode, address referrerAddress) {\n', '        if (mode == 1) {\n', '            _;\n', '        } else if (mode == 2) {\n', '            rl.registrationExt{value: msg.value}(msg.sender, referrerAddress);\n', '        } else {\n', '            rl.registration{value: msg.value}(msg.sender, referrerAddress);\n', '        }\n', '    }\n', '\n', '    modifier checkUpgradeMode(\n', '        uint8 mode,\n', '        uint8 matrix,\n', '        uint8 level\n', '    ) {\n', '        if (mode == 1) {\n', '            _;\n', '        } else {\n', '            rl.occupyMatrix{value: msg.value}(msg.sender, matrix, level);\n', '        }\n', '    }\n', '\n', '    function registrationExt(address referrerAddress, uint8 mode)\n', '        external\n', '        payable\n', '        checkRegisterMode(mode, referrerAddress)\n', '    {\n', '        address userAddress = msg.sender;\n', '        require(msg.value == 0.04 ether, "registration cost 0.04");\n', '        require(!isUserExists(userAddress), "user exists");\n', '        require(isUserExists(referrerAddress), "referrer not exists");\n', '\n', '        uint32 size;\n', '        assembly {\n', '            size := extcodesize(userAddress)\n', '        }\n', '        require(size == 0, "cannot be a contract");\n', '\n', '        users[userAddress].id = lastUserId;\n', '        users[userAddress].referrer = referrerAddress;\n', '        idToAddress[lastUserId] = userAddress;\n', '\n', '        users[userAddress].referrer = referrerAddress;\n', '\n', '        users[userAddress].activeX3Levels[1] = true;\n', '        users[userAddress].activeX4Levels[1] = true;\n', '\n', '        lastUserId++;\n', '\n', '        users[referrerAddress].partnersCount++;\n', '\n', '        address freeX3Referrer = findFreeMatrixReferrer(1, userAddress, 1);\n', '        users[userAddress].x3Matrix[1].currentReferrer = freeX3Referrer;\n', '        occupyX3(userAddress, freeX3Referrer, 1);\n', '\n', '        occupyX4(userAddress, findFreeMatrixReferrer(2, userAddress, 1), 1);\n', '\n', '        emit Registration(\n', '            userAddress,\n', '            referrerAddress,\n', '            users[userAddress].id,\n', '            users[referrerAddress].id\n', '        );\n', '    }\n', '\n', '    function occupyMatrix(\n', '        uint8 matrix,\n', '        uint8 level,\n', '        uint8 mode\n', '    ) external payable checkUpgradeMode(mode, matrix, level) {\n', '        require(\n', '            isUserExists(msg.sender),\n', '            "user is not exists. Register first."\n', '        );\n', '        require(matrix == 1 || matrix == 2, "invalid matrix");\n', '        require(msg.value == levelPrice[level], "invalid price");\n', '        require(level > 1 && level <= MAX_LEVEL, "invalid level");\n', '\n', '        if (matrix == 1) {\n', '            require(\n', '                !users[msg.sender].activeX3Levels[level],\n', '                "level already activated"\n', '            );\n', '            require(users[msg.sender].activeX3Levels[level - 1], "no skipping");\n', '\n', '            if (users[msg.sender].x3Matrix[level - 1].blocked) {\n', '                users[msg.sender].x3Matrix[level - 1].blocked = false;\n', '            }\n', '\n', '            address freeX3Referrer = findFreeMatrixReferrer(\n', '                1,\n', '                msg.sender,\n', '                level\n', '            );\n', '            users[msg.sender].x3Matrix[level].currentReferrer = freeX3Referrer;\n', '            users[msg.sender].activeX3Levels[level] = true;\n', '            occupyX3(msg.sender, freeX3Referrer, level);\n', '\n', '            emit BuyNewLevel(msg.sender, freeX3Referrer, 1, level);\n', '        } else {\n', '            require(\n', '                !users[msg.sender].activeX4Levels[level],\n', '                "level already activated"\n', '            );\n', '            require(users[msg.sender].activeX4Levels[level - 1], "no skipping");\n', '\n', '            if (users[msg.sender].x4Matrix[level - 1].blocked) {\n', '                users[msg.sender].x4Matrix[level - 1].blocked = false;\n', '            }\n', '\n', '            address freeX4Referrer = findFreeMatrixReferrer(\n', '                2,\n', '                msg.sender,\n', '                level\n', '            );\n', '\n', '            users[msg.sender].activeX4Levels[level] = true;\n', '            occupyX4(msg.sender, freeX4Referrer, level);\n', '\n', '            emit BuyNewLevel(msg.sender, freeX4Referrer, 2, level);\n', '        }\n', '    }\n', '\n', '    function occupyX3(\n', '        address userAddress,\n', '        address referrerAddress,\n', '        uint8 level\n', '    ) private {\n', '        users[referrerAddress].x3Matrix[level].referrals.push(userAddress);\n', '\n', '        if (users[referrerAddress].x3Matrix[level].referrals.length < 3) {\n', '            emit NewUserPlace(\n', '                userAddress,\n', '                referrerAddress,\n', '                1,\n', '                level,\n', '                uint8(users[referrerAddress].x3Matrix[level].referrals.length)\n', '            );\n', '            return sendETHDividends(referrerAddress, userAddress, 1, level);\n', '        }\n', '\n', '        emit NewUserPlace(userAddress, referrerAddress, 1, level, 3);\n', '        //close matrix\n', '        users[referrerAddress].x3Matrix[level].referrals = new address[](0);\n', '        if (\n', '            !users[referrerAddress].activeX3Levels[level + 1] &&\n', '            level != MAX_LEVEL\n', '        ) {\n', '            users[referrerAddress].x3Matrix[level].blocked = true;\n', '        }\n', '\n', '        //create new one by recursion\n', '        if (referrerAddress != owner) {\n', '            //check referrer active level\n', '            address freeReferrerAddress = findFreeMatrixReferrer(\n', '                1,\n', '                referrerAddress,\n', '                level\n', '            );\n', '            if (\n', '                users[referrerAddress].x3Matrix[level].currentReferrer !=\n', '                freeReferrerAddress\n', '            ) {\n', '                users[referrerAddress].x3Matrix[level]\n', '                    .currentReferrer = freeReferrerAddress;\n', '            }\n', '\n', '            users[referrerAddress].x3Matrix[level].reinvestCount++;\n', '            emit Reinvest(\n', '                referrerAddress,\n', '                freeReferrerAddress,\n', '                userAddress,\n', '                1,\n', '                level\n', '            );\n', '            occupyX3(referrerAddress, freeReferrerAddress, level);\n', '        } else {\n', '            sendETHDividends(owner, userAddress, 1, level);\n', '            users[owner].x3Matrix[level].reinvestCount++;\n', '            emit Reinvest(owner, address(0), userAddress, 1, level);\n', '        }\n', '    }\n', '\n', '    function occupyX4(\n', '        address userAddress,\n', '        address referrerAddress,\n', '        uint8 level\n', '    ) private {\n', '        require(\n', '            users[referrerAddress].activeX4Levels[level],\n', '            "500. Referrer level is inactive"\n', '        );\n', '\n', '        if (\n', '            users[referrerAddress].x4Matrix[level].firstLevelReferrals.length <\n', '            2\n', '        ) {\n', '            users[referrerAddress].x4Matrix[level].firstLevelReferrals.push(\n', '                userAddress\n', '            );\n', '            emit NewUserPlace(\n', '                userAddress,\n', '                referrerAddress,\n', '                2,\n', '                level,\n', '                uint8(\n', '                    users[referrerAddress].x4Matrix[level]\n', '                        .firstLevelReferrals\n', '                        .length\n', '                )\n', '            );\n', '\n', '            //set current level\n', '            users[userAddress].x4Matrix[level]\n', '                .currentReferrer = referrerAddress;\n', '\n', '            if (referrerAddress == owner) {\n', '                return sendETHDividends(referrerAddress, userAddress, 2, level);\n', '            }\n', '\n', '            address ref = users[referrerAddress].x4Matrix[level]\n', '                .currentReferrer;\n', '            users[ref].x4Matrix[level].secondLevelReferrals.push(userAddress);\n', '\n', '            uint256 len = users[ref].x4Matrix[level].firstLevelReferrals.length;\n', '\n', '            if (\n', '                (len == 2) &&\n', '                (users[ref].x4Matrix[level].firstLevelReferrals[0] ==\n', '                    referrerAddress) &&\n', '                (users[ref].x4Matrix[level].firstLevelReferrals[1] ==\n', '                    referrerAddress)\n', '            ) {\n', '                if (\n', '                    users[referrerAddress].x4Matrix[level]\n', '                        .firstLevelReferrals\n', '                        .length == 1\n', '                ) {\n', '                    emit NewUserPlace(userAddress, ref, 2, level, 5);\n', '                } else {\n', '                    emit NewUserPlace(userAddress, ref, 2, level, 6);\n', '                }\n', '            } else if (\n', '                (len == 1 || len == 2) &&\n', '                users[ref].x4Matrix[level].firstLevelReferrals[0] ==\n', '                referrerAddress\n', '            ) {\n', '                if (\n', '                    users[referrerAddress].x4Matrix[level]\n', '                        .firstLevelReferrals\n', '                        .length == 1\n', '                ) {\n', '                    emit NewUserPlace(userAddress, ref, 2, level, 3);\n', '                } else {\n', '                    emit NewUserPlace(userAddress, ref, 2, level, 4);\n', '                }\n', '            } else if (\n', '                len == 2 &&\n', '                users[ref].x4Matrix[level].firstLevelReferrals[1] ==\n', '                referrerAddress\n', '            ) {\n', '                if (\n', '                    users[referrerAddress].x4Matrix[level]\n', '                        .firstLevelReferrals\n', '                        .length == 1\n', '                ) {\n', '                    emit NewUserPlace(userAddress, ref, 2, level, 5);\n', '                } else {\n', '                    emit NewUserPlace(userAddress, ref, 2, level, 6);\n', '                }\n', '            }\n', '\n', '            return occupyX4Second(userAddress, ref, level);\n', '        }\n', '\n', '        users[referrerAddress].x4Matrix[level].secondLevelReferrals.push(\n', '            userAddress\n', '        );\n', '\n', '        if (users[referrerAddress].x4Matrix[level].closedPart != address(0)) {\n', '            if (\n', '                (users[referrerAddress].x4Matrix[level]\n', '                    .firstLevelReferrals[0] ==\n', '                    users[referrerAddress].x4Matrix[level]\n', '                        .firstLevelReferrals[1]) &&\n', '                (users[referrerAddress].x4Matrix[level]\n', '                    .firstLevelReferrals[0] ==\n', '                    users[referrerAddress].x4Matrix[level].closedPart)\n', '            ) {\n', '                updateX4(userAddress, referrerAddress, level, true);\n', '                return occupyX4Second(userAddress, referrerAddress, level);\n', '            } else if (\n', '                users[referrerAddress].x4Matrix[level].firstLevelReferrals[0] ==\n', '                users[referrerAddress].x4Matrix[level].closedPart\n', '            ) {\n', '                updateX4(userAddress, referrerAddress, level, true);\n', '                return occupyX4Second(userAddress, referrerAddress, level);\n', '            } else {\n', '                updateX4(userAddress, referrerAddress, level, false);\n', '                return occupyX4Second(userAddress, referrerAddress, level);\n', '            }\n', '        }\n', '\n', '        if (\n', '            users[referrerAddress].x4Matrix[level].firstLevelReferrals[1] ==\n', '            userAddress\n', '        ) {\n', '            updateX4(userAddress, referrerAddress, level, false);\n', '            return occupyX4Second(userAddress, referrerAddress, level);\n', '        } else if (\n', '            users[referrerAddress].x4Matrix[level].firstLevelReferrals[0] ==\n', '            userAddress\n', '        ) {\n', '            updateX4(userAddress, referrerAddress, level, true);\n', '            return occupyX4Second(userAddress, referrerAddress, level);\n', '        }\n', '\n', '        if (\n', '            users[users[referrerAddress].x4Matrix[level].firstLevelReferrals[0]]\n', '                .x4Matrix[level]\n', '                .firstLevelReferrals\n', '                .length <=\n', '            users[users[referrerAddress].x4Matrix[level].firstLevelReferrals[1]]\n', '                .x4Matrix[level]\n', '                .firstLevelReferrals\n', '                .length\n', '        ) {\n', '            updateX4(userAddress, referrerAddress, level, false);\n', '        } else {\n', '            updateX4(userAddress, referrerAddress, level, true);\n', '        }\n', '\n', '        occupyX4Second(userAddress, referrerAddress, level);\n', '    }\n', '\n', '    function updateX4(\n', '        address userAddress,\n', '        address referrerAddress,\n', '        uint8 level,\n', '        bool right\n', '    ) private {\n', '        if (!right) {\n', '            users[users[referrerAddress].x4Matrix[level].firstLevelReferrals[0]]\n', '                .x4Matrix[level]\n', '                .firstLevelReferrals\n', '                .push(userAddress);\n', '            emit NewUserPlace(\n', '                userAddress,\n', '                users[referrerAddress].x4Matrix[level].firstLevelReferrals[0],\n', '                2,\n', '                level,\n', '                uint8(\n', '                    users[users[referrerAddress].x4Matrix[level]\n', '                        .firstLevelReferrals[0]]\n', '                        .x4Matrix[level]\n', '                        .firstLevelReferrals\n', '                        .length\n', '                )\n', '            );\n', '            emit NewUserPlace(\n', '                userAddress,\n', '                referrerAddress,\n', '                2,\n', '                level,\n', '                2 +\n', '                    uint8(\n', '                        users[users[referrerAddress].x4Matrix[level]\n', '                            .firstLevelReferrals[0]]\n', '                            .x4Matrix[level]\n', '                            .firstLevelReferrals\n', '                            .length\n', '                    )\n', '            );\n', '            //set current level\n', '            users[userAddress].x4Matrix[level]\n', '                .currentReferrer = users[referrerAddress].x4Matrix[level]\n', '                .firstLevelReferrals[0];\n', '        } else {\n', '            users[users[referrerAddress].x4Matrix[level].firstLevelReferrals[1]]\n', '                .x4Matrix[level]\n', '                .firstLevelReferrals\n', '                .push(userAddress);\n', '            emit NewUserPlace(\n', '                userAddress,\n', '                users[referrerAddress].x4Matrix[level].firstLevelReferrals[1],\n', '                2,\n', '                level,\n', '                uint8(\n', '                    users[users[referrerAddress].x4Matrix[level]\n', '                        .firstLevelReferrals[1]]\n', '                        .x4Matrix[level]\n', '                        .firstLevelReferrals\n', '                        .length\n', '                )\n', '            );\n', '            emit NewUserPlace(\n', '                userAddress,\n', '                referrerAddress,\n', '                2,\n', '                level,\n', '                4 +\n', '                    uint8(\n', '                        users[users[referrerAddress].x4Matrix[level]\n', '                            .firstLevelReferrals[1]]\n', '                            .x4Matrix[level]\n', '                            .firstLevelReferrals\n', '                            .length\n', '                    )\n', '            );\n', '            //set current level\n', '            users[userAddress].x4Matrix[level]\n', '                .currentReferrer = users[referrerAddress].x4Matrix[level]\n', '                .firstLevelReferrals[1];\n', '        }\n', '    }\n', '\n', '    function occupyX4Second(\n', '        address userAddress,\n', '        address referrerAddress,\n', '        uint8 level\n', '    ) private {\n', '        if (\n', '            users[referrerAddress].x4Matrix[level].secondLevelReferrals.length <\n', '            4\n', '        ) {\n', '            return sendETHDividends(referrerAddress, userAddress, 2, level);\n', '        }\n', '\n', '        address[] memory _X4Matrix = users[users[referrerAddress]\n', '            .x4Matrix[level]\n', '            .currentReferrer]\n', '            .x4Matrix[level]\n', '            .firstLevelReferrals;\n', '\n', '        if (_X4Matrix.length == 2) {\n', '            if (\n', '                _X4Matrix[0] == referrerAddress ||\n', '                _X4Matrix[1] == referrerAddress\n', '            ) {\n', '                users[users[referrerAddress].x4Matrix[level].currentReferrer]\n', '                    .x4Matrix[level]\n', '                    .closedPart = referrerAddress;\n', '            }\n', '        } else if (_X4Matrix.length == 1) {\n', '            if (_X4Matrix[0] == referrerAddress) {\n', '                users[users[referrerAddress].x4Matrix[level].currentReferrer]\n', '                    .x4Matrix[level]\n', '                    .closedPart = referrerAddress;\n', '            }\n', '        }\n', '\n', '        users[referrerAddress].x4Matrix[level]\n', '            .firstLevelReferrals = new address[](0);\n', '        users[referrerAddress].x4Matrix[level]\n', '            .secondLevelReferrals = new address[](0);\n', '        users[referrerAddress].x4Matrix[level].closedPart = address(0);\n', '\n', '        if (\n', '            !users[referrerAddress].activeX4Levels[level + 1] &&\n', '            level != MAX_LEVEL\n', '        ) {\n', '            users[referrerAddress].x4Matrix[level].blocked = true;\n', '        }\n', '\n', '        users[referrerAddress].x4Matrix[level].reinvestCount++;\n', '\n', '        if (referrerAddress != owner) {\n', '            address freeReferrerAddress = findFreeMatrixReferrer(\n', '                2,\n', '                referrerAddress,\n', '                level\n', '            );\n', '\n', '            emit Reinvest(\n', '                referrerAddress,\n', '                freeReferrerAddress,\n', '                userAddress,\n', '                2,\n', '                level\n', '            );\n', '            occupyX4(referrerAddress, freeReferrerAddress, level);\n', '        } else {\n', '            emit Reinvest(owner, address(0), userAddress, 2, level);\n', '            sendETHDividends(owner, userAddress, 2, level);\n', '        }\n', '    }\n', '\n', '    function findFreeMatrixReferrer(\n', '        uint8 matrix,\n', '        address userAddress,\n', '        uint8 level\n', '    ) public view returns (address) {\n', '        if (matrix == 1) {\n', '            while (true) {\n', '                if (users[users[userAddress].referrer].activeX3Levels[level]) {\n', '                    return users[userAddress].referrer;\n', '                }\n', '\n', '                userAddress = users[userAddress].referrer;\n', '            }\n', '        } else {\n', '            while (true) {\n', '                if (users[users[userAddress].referrer].activeX4Levels[level]) {\n', '                    return users[userAddress].referrer;\n', '                }\n', '\n', '                userAddress = users[userAddress].referrer;\n', '            }\n', '        }\n', '    }\n', '\n', '    function findEthReceiver(\n', '        address userAddress,\n', '        address _from,\n', '        uint8 matrix,\n', '        uint8 level\n', '    ) private returns (address, bool) {\n', '        address receiver = userAddress;\n', '        bool isExtraDividends;\n', '        if (matrix == 1) {\n', '            while (true) {\n', '                if (users[receiver].x3Matrix[level].blocked) {\n', '                    emit MissedEthReceive(receiver, _from, 1, level);\n', '                    isExtraDividends = true;\n', '                    receiver = users[receiver].x3Matrix[level].currentReferrer;\n', '                } else {\n', '                    return (receiver, isExtraDividends);\n', '                }\n', '            }\n', '        } else {\n', '            while (true) {\n', '                if (users[receiver].x4Matrix[level].blocked) {\n', '                    emit MissedEthReceive(receiver, _from, 2, level);\n', '                    isExtraDividends = true;\n', '                    receiver = users[receiver].x4Matrix[level].currentReferrer;\n', '                } else {\n', '                    return (receiver, isExtraDividends);\n', '                }\n', '            }\n', '        }\n', '    }\n', '\n', '    function sendETHDividends(\n', '        address userAddress,\n', '        address _from,\n', '        uint8 matrix,\n', '        uint8 level\n', '    ) private {\n', '        (address receiver, bool isExtraDividends) = findEthReceiver(\n', '            userAddress,\n', '            _from,\n', '            matrix,\n', '            level\n', '        );\n', '\n', '        if (!address(uint160(receiver)).send(levelPrice[level])) {\n', '            return address(uint160(receiver)).transfer(address(this).balance);\n', '        }\n', '\n', '        if (isExtraDividends) {\n', '            emit SentExtraEthDividends(_from, receiver, matrix, level);\n', '        }\n', '    }\n', '\n', '    function isUserExists(address user) public view returns (bool) {\n', '        return (users[user].id != 0);\n', '    }\n', '\n', '    function changeDependentContractAddress() public override {\n', '        rl = IRelayer(registry.getLatestAddress("RL"));\n', '    }\n', '}']