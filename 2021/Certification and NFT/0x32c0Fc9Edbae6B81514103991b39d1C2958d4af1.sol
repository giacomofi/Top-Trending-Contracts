['// SPDX-License-Identifier: GPL-3.0-or-later\n', 'pragma solidity 0.6.9;\n', 'pragma experimental ABIEncoderV2;\n', '\n', 'import { IERC20 } from "@openzeppelin/contracts-ethereum-package/contracts/token/ERC20/IERC20.sol";\n', 'import { SafeMath } from "@openzeppelin/contracts-ethereum-package/contracts/math/SafeMath.sol";\n', 'import { MerkleRedeemUpgradeSafe } from "./Balancer/MerkleRedeemUpgradeSafe.sol";\n', 'import { Decimal } from "../utils/Decimal.sol";\n', 'import { DecimalERC20 } from "../utils/DecimalERC20.sol";\n', 'import { BlockContext } from "../utils/BlockContext.sol";\n', '\n', 'contract PerpRewardVesting is MerkleRedeemUpgradeSafe, BlockContext {\n', '    using Decimal for Decimal.decimal;\n', '    using SafeMath for uint256;\n', '\n', '    //**********************************************************//\n', '    //    The below state variables can not change the order    //\n', '    //**********************************************************//\n', '    // {weekMerkleRootsIndex: timestamp}\n', '    mapping(uint256 => uint256) public merkleRootTimestampMap;\n', '\n', '    // array of weekMerkleRootsIndex\n', '    uint256[] public merkleRootIndexes;\n', '\n', '    uint256 public vestingPeriod;\n', '\n', '    //**********************************************************//\n', '    //    The above state variables can not change the order    //\n', '    //**********************************************************//\n', '\n', '    //◥◤◥◤◥◤◥◤◥◤◥◤◥◤◥◤ add state variables below ◥◤◥◤◥◤◥◤◥◤◥◤◥◤◥◤//\n', '\n', '    //◢◣◢◣◢◣◢◣◢◣◢◣◢◣◢◣ add state variable, ables above ◢◣◢◣◢◣◢◣◢◣◢◣◢◣◢◣//\n', '    uint256[50] private __gap;\n', '\n', '    function initialize(IERC20 _token, uint256 _vestingPeriod) external initializer {\n', '        require(address(_token) != address(0), "Invalid input");\n', '        __MerkleRedeem_init(_token);\n', '        vestingPeriod = _vestingPeriod;\n', '    }\n', '\n', '    function claimWeeks(address _account, Claim[] memory _claims) public virtual override {\n', '        for (uint256 i; i < _claims.length; i++) {\n', '            claimWeek(_account, _claims[i].week, _claims[i].balance, _claims[i].merkleProof);\n', '        }\n', '    }\n', '\n', '    function claimWeek(\n', '        address _account,\n', '        uint256 _week,\n', '        uint256 _claimedBalance,\n', '        bytes32[] memory _merkleProof\n', '    ) public virtual override {\n', '        //\n', '        //                      +----------------+\n', '        //                      | vesting period |\n', '        //           +----------------+----------+\n', '        //           | vesting period |          |\n', '        //  ---------+------+---+-----+------+---+\n', '        //           |          |     |     now  |\n', '        //           |        week2   |          merkleRootTimestampMap[week1]\n', '        //           |                |\n', '        //         week1              merkleRootTimestampMap[week1]\n', '        //\n', '        //  week1 -> claimable\n', '        //  week2 -> non-claimable\n', '        //\n', '        require(\n', '            _blockTimestamp() >= merkleRootTimestampMap[_week] && merkleRootTimestampMap[_week] > 0,\n', '            "Invalid claim"\n', '        );\n', '        super.claimWeek(_account, _week, _claimedBalance, _merkleProof);\n', '    }\n', '\n', '    function seedAllocations(\n', '        uint256 _week,\n', '        bytes32 _merkleRoot,\n', '        uint256 _totalAllocation\n', '    ) public override onlyOwner {\n', '        super.seedAllocations(_week, _merkleRoot, _totalAllocation);\n', '        merkleRootTimestampMap[_week] = _blockTimestamp().add(vestingPeriod);\n', '        merkleRootIndexes.push(_week);\n', '    }\n', '\n', '    //\n', '    // INTERNAL\n', '    //\n', '\n', '    function getLengthOfMerkleRoots() external view returns (uint256) {\n', '        return merkleRootIndexes.length;\n', '    }\n', '}\n', '\n', '// source: https://github.com/balancer-labs/erc20-redeemable/blob/master/merkle/contracts/MerkleRedeem.sol\n', '// changes:\n', '// 1. add license and update solidity version to 0.6.9\n', '// 2. make it upgradeable\n', '// 3. add virtual modifier in claim functions\n', '\n', '// SPDX-License-Identifier: GPL-3.0-or-later\n', 'pragma solidity 0.6.9;\n', 'pragma experimental ABIEncoderV2;\n', '\n', 'import { MerkleProof } from "@openzeppelin/contracts-ethereum-package/contracts/cryptography/MerkleProof.sol";\n', 'import { IERC20 } from "@openzeppelin/contracts-ethereum-package/contracts/token/ERC20/IERC20.sol";\n', 'import { PerpFiOwnableUpgrade } from "../../utils/PerpFiOwnableUpgrade.sol";\n', '\n', 'contract MerkleRedeemUpgradeSafe is PerpFiOwnableUpgrade {\n', '    event Claimed(address _claimant, uint256 _balance);\n', '\n', '    //**********************************************************//\n', '    //    The below state variables can not change the order    //\n', '    //**********************************************************//\n', '    // Recorded weeks\n', '    mapping(uint256 => bytes32) public weekMerkleRoots;\n', '    mapping(uint256 => mapping(address => bool)) public claimed;\n', '\n', '    IERC20 public token;\n', '\n', '    //**********************************************************//\n', '    //    The above state variables can not change the order    //\n', '    //**********************************************************//\n', '\n', '    //◥◤◥◤◥◤◥◤◥◤◥◤◥◤◥◤ add state variables below ◥◤◥◤◥◤◥◤◥◤◥◤◥◤◥◤//\n', '\n', '    //◢◣◢◣◢◣◢◣◢◣◢◣◢◣◢◣ add state variables above ◢◣◢◣◢◣◢◣◢◣◢◣◢◣◢◣//\n', '    uint256[50] private __gap;\n', '\n', '    //\n', '    // FUNCTIONS\n', '    //\n', '\n', '    function __MerkleRedeem_init(IERC20 _token) internal initializer {\n', '        __Ownable_init();\n', '        __MerkleRedeem_init_unchained(_token);\n', '    }\n', '\n', '    function __MerkleRedeem_init_unchained(IERC20 _token) internal initializer {\n', '        token = _token;\n', '    }\n', '\n', '    function disburse(address _liquidityProvider, uint256 _balance) private {\n', '        if (_balance > 0) {\n', '            emit Claimed(_liquidityProvider, _balance);\n', '            require(token.transfer(_liquidityProvider, _balance), "ERR_TRANSFER_FAILED");\n', '        }\n', '    }\n', '\n', '    function claimWeek(\n', '        address _liquidityProvider,\n', '        uint256 _week,\n', '        uint256 _claimedBalance,\n', '        bytes32[] memory _merkleProof\n', '    ) public virtual {\n', '        require(!claimed[_week][_liquidityProvider], "Claimed already");\n', '        require(verifyClaim(_liquidityProvider, _week, _claimedBalance, _merkleProof), "Incorrect merkle proof");\n', '\n', '        claimed[_week][_liquidityProvider] = true;\n', '        disburse(_liquidityProvider, _claimedBalance);\n', '    }\n', '\n', '    struct Claim {\n', '        uint256 week;\n', '        uint256 balance;\n', '        bytes32[] merkleProof;\n', '    }\n', '\n', '    function claimWeeks(address _liquidityProvider, Claim[] memory claims) public virtual {\n', '        uint256 totalBalance = 0;\n', '        Claim memory claim;\n', '        for (uint256 i = 0; i < claims.length; i++) {\n', '            claim = claims[i];\n', '\n', '            require(!claimed[claim.week][_liquidityProvider], "Claimed already");\n', '            require(\n', '                verifyClaim(_liquidityProvider, claim.week, claim.balance, claim.merkleProof),\n', '                "Incorrect merkle proof"\n', '            );\n', '\n', '            totalBalance += claim.balance;\n', '            claimed[claim.week][_liquidityProvider] = true;\n', '        }\n', '        disburse(_liquidityProvider, totalBalance);\n', '    }\n', '\n', '    function claimStatus(\n', '        address _liquidityProvider,\n', '        uint256 _begin,\n', '        uint256 _end\n', '    ) external view returns (bool[] memory) {\n', '        uint256 size = 1 + _end - _begin;\n', '        bool[] memory arr = new bool[](size);\n', '        for (uint256 i = 0; i < size; i++) {\n', '            arr[i] = claimed[_begin + i][_liquidityProvider];\n', '        }\n', '        return arr;\n', '    }\n', '\n', '    function merkleRoots(uint256 _begin, uint256 _end) external view returns (bytes32[] memory) {\n', '        uint256 size = 1 + _end - _begin;\n', '        bytes32[] memory arr = new bytes32[](size);\n', '        for (uint256 i = 0; i < size; i++) {\n', '            arr[i] = weekMerkleRoots[_begin + i];\n', '        }\n', '        return arr;\n', '    }\n', '\n', '    function verifyClaim(\n', '        address _liquidityProvider,\n', '        uint256 _week,\n', '        uint256 _claimedBalance,\n', '        bytes32[] memory _merkleProof\n', '    ) public view virtual returns (bool valid) {\n', '        bytes32 leaf = keccak256(abi.encodePacked(_liquidityProvider, _claimedBalance));\n', '        return MerkleProof.verify(_merkleProof, weekMerkleRoots[_week], leaf);\n', '    }\n', '\n', '    function seedAllocations(\n', '        uint256 _week,\n', '        bytes32 _merkleRoot,\n', '        uint256 _totalAllocation\n', '    ) public virtual {\n', '        require(weekMerkleRoots[_week] == bytes32(0), "cannot rewrite merkle root");\n', '        weekMerkleRoots[_week] = _merkleRoot;\n', '\n', '        require(token.transferFrom(msg.sender, address(this), _totalAllocation), "ERR_TRANSFER_FAILED");\n', '    }\n', '}\n', '\n', '// SPDX-License-Identifier: GPL-3.0-or-later\n', 'pragma solidity 0.6.9;\n', '\n', 'import { ContextUpgradeSafe } from "@openzeppelin/contracts-ethereum-package/contracts/GSN/Context.sol";\n', '\n', '// copy from openzeppelin Ownable, only modify how the owner transfer\n', '/**\n', ' * @dev Contract module which provides a basic access control mechanism, where\n', ' * there is an account (an owner) that can be granted exclusive access to\n', ' * specific functions.\n', ' *\n', ' * By default, the owner account will be the one that deploys the contract. This\n', ' * can later be changed with {transferOwnership}.\n', ' *\n', ' * This module is used through inheritance. It will make available the modifier\n', ' * `onlyOwner`, which can be applied to your functions to restrict their use to\n', ' * the owner.\n', ' */\n', 'contract PerpFiOwnableUpgrade is ContextUpgradeSafe {\n', '    address private _owner;\n', '    address private _candidate;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '     * @dev Initializes the contract setting the deployer as the initial owner.\n', '     */\n', '\n', '    function __Ownable_init() internal initializer {\n', '        __Context_init_unchained();\n', '        __Ownable_init_unchained();\n', '    }\n', '\n', '    function __Ownable_init_unchained() internal initializer {\n', '        address msgSender = _msgSender();\n', '        _owner = msgSender;\n', '        emit OwnershipTransferred(address(0), msgSender);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the address of the current owner.\n', '     */\n', '    function owner() public view returns (address) {\n', '        return _owner;\n', '    }\n', '\n', '    function candidate() public view returns (address) {\n', '        return _candidate;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(_owner == _msgSender(), "PerpFiOwnableUpgrade: caller is not the owner");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Leaves the contract without owner. It will not be possible to call\n', '     * `onlyOwner` functions anymore. Can only be called by the current owner.\n', '     *\n', '     * NOTE: Renouncing ownership will leave the contract without an owner,\n', '     * thereby removing any functionality that is only available to the owner.\n', '     */\n', '    function renounceOwnership() public virtual onlyOwner {\n', '        emit OwnershipTransferred(_owner, address(0));\n', '        _owner = address(0);\n', '    }\n', '\n', '    /**\n', '     * @dev Set ownership of the contract to a new account (`newOwner`).\n', '     * Can only be called by the current owner.\n', '     */\n', '    function setOwner(address newOwner) public onlyOwner {\n', '        require(newOwner != address(0), "PerpFiOwnableUpgrade: zero address");\n', '        require(newOwner != _owner, "PerpFiOwnableUpgrade: same as original");\n', '        require(newOwner != _candidate, "PerpFiOwnableUpgrade: same as candidate");\n', '        _candidate = newOwner;\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers ownership of the contract to a new account (`_candidate`).\n', '     * Can only be called by the new owner.\n', '     */\n', '    function updateOwner() public {\n', '        require(_candidate != address(0), "PerpFiOwnableUpgrade: candidate is zero address");\n', '        require(_candidate == _msgSender(), "PerpFiOwnableUpgrade: not the new owner");\n', '\n', '        emit OwnershipTransferred(_owner, _candidate);\n', '        _owner = _candidate;\n', '        _candidate = address(0);\n', '    }\n', '\n', '    uint256[50] private __gap;\n', '}\n', '\n', '// SPDX-License-Identifier: GPL-3.0-or-later\n', 'pragma solidity 0.6.9;\n', '\n', 'import { SafeMath } from "@openzeppelin/contracts-ethereum-package/contracts/math/SafeMath.sol";\n', 'import { DecimalMath } from "./DecimalMath.sol";\n', '\n', 'library Decimal {\n', '    using DecimalMath for uint256;\n', '    using SafeMath for uint256;\n', '\n', '    struct decimal {\n', '        uint256 d;\n', '    }\n', '\n', '    function zero() internal pure returns (decimal memory) {\n', '        return decimal(0);\n', '    }\n', '\n', '    function one() internal pure returns (decimal memory) {\n', '        return decimal(DecimalMath.unit(18));\n', '    }\n', '\n', '    function toUint(decimal memory x) internal pure returns (uint256) {\n', '        return x.d;\n', '    }\n', '\n', '    function modD(decimal memory x, decimal memory y) internal pure returns (decimal memory) {\n', '        return decimal(x.d.mul(DecimalMath.unit(18)) % y.d);\n', '    }\n', '\n', '    function cmp(decimal memory x, decimal memory y) internal pure returns (int8) {\n', '        if (x.d > y.d) {\n', '            return 1;\n', '        } else if (x.d < y.d) {\n', '            return -1;\n', '        }\n', '        return 0;\n', '    }\n', '\n', '    /// @dev add two decimals\n', '    function addD(decimal memory x, decimal memory y) internal pure returns (decimal memory) {\n', '        decimal memory t;\n', '        t.d = x.d.add(y.d);\n', '        return t;\n', '    }\n', '\n', '    /// @dev subtract two decimals\n', '    function subD(decimal memory x, decimal memory y) internal pure returns (decimal memory) {\n', '        decimal memory t;\n', '        t.d = x.d.sub(y.d);\n', '        return t;\n', '    }\n', '\n', '    /// @dev multiple two decimals\n', '    function mulD(decimal memory x, decimal memory y) internal pure returns (decimal memory) {\n', '        decimal memory t;\n', '        t.d = x.d.muld(y.d);\n', '        return t;\n', '    }\n', '\n', '    /// @dev multiple a decimal by a uint256\n', '    function mulScalar(decimal memory x, uint256 y) internal pure returns (decimal memory) {\n', '        decimal memory t;\n', '        t.d = x.d.mul(y);\n', '        return t;\n', '    }\n', '\n', '    /// @dev divide two decimals\n', '    function divD(decimal memory x, decimal memory y) internal pure returns (decimal memory) {\n', '        decimal memory t;\n', '        t.d = x.d.divd(y.d);\n', '        return t;\n', '    }\n', '\n', '    /// @dev divide a decimal by a uint256\n', '    function divScalar(decimal memory x, uint256 y) internal pure returns (decimal memory) {\n', '        decimal memory t;\n', '        t.d = x.d.div(y);\n', '        return t;\n', '    }\n', '}\n', '\n', '// SPDX-License-Identifier: GPL-3.0-or-later\n', 'pragma solidity 0.6.9;\n', '\n', 'import { SafeMath } from "@openzeppelin/contracts-ethereum-package/contracts/math/SafeMath.sol";\n', '\n', '/// @dev Implements simple fixed point math add, sub, mul and div operations.\n', '/// @author Alberto Cuesta Cañada\n', 'library DecimalMath {\n', '    using SafeMath for uint256;\n', '\n', '    /// @dev Returns 1 in the fixed point representation, with `decimals` decimals.\n', '    function unit(uint8 decimals) internal pure returns (uint256) {\n', '        return 10**uint256(decimals);\n', '    }\n', '\n', '    /// @dev Adds x and y, assuming they are both fixed point with 18 decimals.\n', '    function addd(uint256 x, uint256 y) internal pure returns (uint256) {\n', '        return x.add(y);\n', '    }\n', '\n', '    /// @dev Subtracts y from x, assuming they are both fixed point with 18 decimals.\n', '    function subd(uint256 x, uint256 y) internal pure returns (uint256) {\n', '        return x.sub(y);\n', '    }\n', '\n', '    /// @dev Multiplies x and y, assuming they are both fixed point with 18 digits.\n', '    function muld(uint256 x, uint256 y) internal pure returns (uint256) {\n', '        return muld(x, y, 18);\n', '    }\n', '\n', '    /// @dev Multiplies x and y, assuming they are both fixed point with `decimals` digits.\n', '    function muld(\n', '        uint256 x,\n', '        uint256 y,\n', '        uint8 decimals\n', '    ) internal pure returns (uint256) {\n', '        return x.mul(y).div(unit(decimals));\n', '    }\n', '\n', '    /// @dev Divides x between y, assuming they are both fixed point with 18 digits.\n', '    function divd(uint256 x, uint256 y) internal pure returns (uint256) {\n', '        return divd(x, y, 18);\n', '    }\n', '\n', '    /// @dev Divides x between y, assuming they are both fixed point with `decimals` digits.\n', '    function divd(\n', '        uint256 x,\n', '        uint256 y,\n', '        uint8 decimals\n', '    ) internal pure returns (uint256) {\n', '        return x.mul(unit(decimals)).div(y);\n', '    }\n', '}\n', '\n', '// SPDX-License-Identifier: GPL-3.0-or-later\n', 'pragma solidity 0.6.9;\n', '\n', 'import { IERC20 } from "@openzeppelin/contracts-ethereum-package/contracts/token/ERC20/IERC20.sol";\n', 'import { SafeMath } from "@openzeppelin/contracts-ethereum-package/contracts/math/SafeMath.sol";\n', 'import { Decimal } from "./Decimal.sol";\n', '\n', 'abstract contract DecimalERC20 {\n', '    using SafeMath for uint256;\n', '    using Decimal for Decimal.decimal;\n', '\n', '    mapping(address => uint256) private decimalMap;\n', '\n', '    //◥◤◥◤◥◤◥◤◥◤◥◤◥◤◥◤ add state variables below ◥◤◥◤◥◤◥◤◥◤◥◤◥◤◥◤//\n', '\n', '    //◢◣◢◣◢◣◢◣◢◣◢◣◢◣◢◣ add state variables above ◢◣◢◣◢◣◢◣◢◣◢◣◢◣◢◣//\n', '    uint256[50] private __gap;\n', '\n', '    //\n', '    // INTERNAL functions\n', '    //\n', '\n', '    // CAUTION: do not input _from == _to s.t. this function will always fail\n', '    function _transfer(\n', '        IERC20 _token,\n', '        address _to,\n', '        Decimal.decimal memory _value\n', '    ) internal {\n', '        _updateDecimal(address(_token));\n', '        Decimal.decimal memory balanceBefore = _balanceOf(_token, _to);\n', '        uint256 roundedDownValue = _toUint(_token, _value);\n', '\n', '        // solhint-disable avoid-low-level-calls\n', '        (bool success, bytes memory data) =\n', '            address(_token).call(abi.encodeWithSelector(_token.transfer.selector, _to, roundedDownValue));\n', '\n', '        require(success && (data.length == 0 || abi.decode(data, (bool))), "DecimalERC20: transfer failed");\n', '        _validateBalance(_token, _to, roundedDownValue, balanceBefore);\n', '    }\n', '\n', '    function _transferFrom(\n', '        IERC20 _token,\n', '        address _from,\n', '        address _to,\n', '        Decimal.decimal memory _value\n', '    ) internal {\n', '        _updateDecimal(address(_token));\n', '        Decimal.decimal memory balanceBefore = _balanceOf(_token, _to);\n', '        uint256 roundedDownValue = _toUint(_token, _value);\n', '\n', '        // solhint-disable avoid-low-level-calls\n', '        (bool success, bytes memory data) =\n', '            address(_token).call(abi.encodeWithSelector(_token.transferFrom.selector, _from, _to, roundedDownValue));\n', '\n', '        require(success && (data.length == 0 || abi.decode(data, (bool))), "DecimalERC20: transferFrom failed");\n', '        _validateBalance(_token, _to, roundedDownValue, balanceBefore);\n', '    }\n', '\n', '    function _approve(\n', '        IERC20 _token,\n', '        address _spender,\n', '        Decimal.decimal memory _value\n', '    ) internal {\n', '        _updateDecimal(address(_token));\n', '        // to be compatible with some erc20 tokens like USDT\n', '        __approve(_token, _spender, Decimal.zero());\n', '        __approve(_token, _spender, _value);\n', '    }\n', '\n', '    //\n', '    // VIEW\n', '    //\n', '    function _allowance(\n', '        IERC20 _token,\n', '        address _owner,\n', '        address _spender\n', '    ) internal view returns (Decimal.decimal memory) {\n', '        return _toDecimal(_token, _token.allowance(_owner, _spender));\n', '    }\n', '\n', '    function _balanceOf(IERC20 _token, address _owner) internal view returns (Decimal.decimal memory) {\n', '        return _toDecimal(_token, _token.balanceOf(_owner));\n', '    }\n', '\n', '    function _totalSupply(IERC20 _token) internal view returns (Decimal.decimal memory) {\n', '        return _toDecimal(_token, _token.totalSupply());\n', '    }\n', '\n', '    function _toDecimal(IERC20 _token, uint256 _number) internal view returns (Decimal.decimal memory) {\n', '        uint256 tokenDecimals = _getTokenDecimals(address(_token));\n', '        if (tokenDecimals >= 18) {\n', '            return Decimal.decimal(_number.div(10**(tokenDecimals.sub(18))));\n', '        }\n', '\n', '        return Decimal.decimal(_number.mul(10**(uint256(18).sub(tokenDecimals))));\n', '    }\n', '\n', '    function _toUint(IERC20 _token, Decimal.decimal memory _decimal) internal view returns (uint256) {\n', '        uint256 tokenDecimals = _getTokenDecimals(address(_token));\n', '        if (tokenDecimals >= 18) {\n', '            return _decimal.toUint().mul(10**(tokenDecimals.sub(18)));\n', '        }\n', '        return _decimal.toUint().div(10**(uint256(18).sub(tokenDecimals)));\n', '    }\n', '\n', '    function _getTokenDecimals(address _token) internal view returns (uint256) {\n', '        uint256 tokenDecimals = decimalMap[_token];\n', '        if (tokenDecimals == 0) {\n', '            (bool success, bytes memory data) = _token.staticcall(abi.encodeWithSignature("decimals()"));\n', '            require(success && data.length != 0, "DecimalERC20: get decimals failed");\n', '            tokenDecimals = abi.decode(data, (uint256));\n', '        }\n', '        return tokenDecimals;\n', '    }\n', '\n', '    //\n', '    // PRIVATE\n', '    //\n', '    function _updateDecimal(address _token) private {\n', '        uint256 tokenDecimals = _getTokenDecimals(_token);\n', '        if (decimalMap[_token] != tokenDecimals) {\n', '            decimalMap[_token] = tokenDecimals;\n', '        }\n', '    }\n', '\n', '    function __approve(\n', '        IERC20 _token,\n', '        address _spender,\n', '        Decimal.decimal memory _value\n', '    ) private {\n', '        // solhint-disable avoid-low-level-calls\n', '        (bool success, bytes memory data) =\n', '            address(_token).call(abi.encodeWithSelector(_token.approve.selector, _spender, _toUint(_token, _value)));\n', '        require(success && (data.length == 0 || abi.decode(data, (bool))), "DecimalERC20: approve failed");\n', '    }\n', '\n', "    // To prevent from deflationary token, check receiver's balance is as expectation.\n", '    function _validateBalance(\n', '        IERC20 _token,\n', '        address _to,\n', '        uint256 _roundedDownValue,\n', '        Decimal.decimal memory _balanceBefore\n', '    ) private view {\n', '        require(\n', '            _balanceOf(_token, _to).cmp(_balanceBefore.addD(_toDecimal(_token, _roundedDownValue))) == 0,\n', '            "DecimalERC20: balance inconsistent"\n', '        );\n', '    }\n', '}\n', '\n', '// SPDX-License-Identifier: GPL-3.0-or-later\n', 'pragma solidity 0.6.9;\n', '\n', '// wrap block.xxx functions for testing\n', '// only support timestamp and number so far\n', 'abstract contract BlockContext {\n', '    //◥◤◥◤◥◤◥◤◥◤◥◤◥◤◥◤ add state variables below ◥◤◥◤◥◤◥◤◥◤◥◤◥◤◥◤//\n', '\n', '    //◢◣◢◣◢◣◢◣◢◣◢◣◢◣◢◣ add state variables above ◢◣◢◣◢◣◢◣◢◣◢◣◢◣◢◣//\n', '    uint256[50] private __gap;\n', '\n', '    function _blockTimestamp() internal view virtual returns (uint256) {\n', '        return block.timestamp;\n', '    }\n', '\n', '    function _blockNumber() internal view virtual returns (uint256) {\n', '        return block.number;\n', '    }\n', '}\n', '\n', 'pragma solidity ^0.6.0;\n', '\n', '/**\n', ' * @dev Interface of the ERC20 standard as defined in the EIP.\n', ' */\n', 'interface IERC20 {\n', '    /**\n', '     * @dev Returns the amount of tokens in existence.\n', '     */\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    /**\n', '     * @dev Returns the amount of tokens owned by `account`.\n', '     */\n', '    function balanceOf(address account) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Moves `amount` tokens from the caller's account to `recipient`.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Returns the remaining number of tokens that `spender` will be\n', '     * allowed to spend on behalf of `owner` through {transferFrom}. This is\n', '     * zero by default.\n', '     *\n', '     * This value changes when {approve} or {transferFrom} are called.\n', '     */\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * IMPORTANT: Beware that changing an allowance with this method brings the risk\n', '     * that someone may use both the old and the new allowance by unfortunate\n', '     * transaction ordering. One possible solution to mitigate this race\n', "     * condition is to first reduce the spender's allowance to 0 and set the\n", '     * desired value afterwards:\n', '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     *\n', '     * Emits an {Approval} event.\n', '     */\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Moves `amount` tokens from `sender` to `recipient` using the\n', "     * allowance mechanism. `amount` is then deducted from the caller's\n", '     * allowance.\n', '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Emitted when `value` tokens are moved from one account (`from`) to\n', '     * another (`to`).\n', '     *\n', '     * Note that `value` may be zero.\n', '     */\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    /**\n', '     * @dev Emitted when the allowance of a `spender` for an `owner` is set by\n', '     * a call to {approve}. `value` is the new allowance.\n', '     */\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'pragma solidity ^0.6.0;\n', '\n', '/**\n', " * @dev Wrappers over Solidity's arithmetic operations with added overflow\n", ' * checks.\n', ' *\n', ' * Arithmetic operations in Solidity wrap on overflow. This can easily result\n', ' * in bugs, because programmers usually assume that an overflow raises an\n', ' * error, which is the standard behavior in high level programming languages.\n', ' * `SafeMath` restores this intuition by reverting the transaction when an\n', ' * operation overflows.\n', ' *\n', ' * Using this library instead of the unchecked operations eliminates an entire\n', " * class of bugs, so it's recommended to use it always.\n", ' */\n', 'library SafeMath {\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `+` operator.\n", '     *\n', '     * Requirements:\n', '     * - Addition cannot overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `*` operator.\n", '     *\n', '     * Requirements:\n', '     * - Multiplication cannot overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        // Solidity only automatically asserts when dividing by 0\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts with custom message when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '\n', 'pragma solidity ^0.6.0;\n', '\n', '/**\n', ' * @dev These functions deal with verification of Merkle trees (hash trees),\n', ' */\n', 'library MerkleProof {\n', '    /**\n', '     * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree\n', '     * defined by `root`. For this, a `proof` must be provided, containing\n', '     * sibling hashes on the branch from the leaf to the root of the tree. Each\n', '     * pair of leaves and each pair of pre-images are assumed to be sorted.\n', '     */\n', '    function verify(bytes32[] memory proof, bytes32 root, bytes32 leaf) internal pure returns (bool) {\n', '        bytes32 computedHash = leaf;\n', '\n', '        for (uint256 i = 0; i < proof.length; i++) {\n', '            bytes32 proofElement = proof[i];\n', '\n', '            if (computedHash <= proofElement) {\n', '                // Hash(current computed hash + current element of the proof)\n', '                computedHash = keccak256(abi.encodePacked(computedHash, proofElement));\n', '            } else {\n', '                // Hash(current element of the proof + current computed hash)\n', '                computedHash = keccak256(abi.encodePacked(proofElement, computedHash));\n', '            }\n', '        }\n', '\n', '        // Check if the computed hash (root) is equal to the provided root\n', '        return computedHash == root;\n', '    }\n', '}\n', '\n', 'pragma solidity ^0.6.0;\n', 'import "../Initializable.sol";\n', '\n', '/*\n', ' * @dev Provides information about the current execution context, including the\n', ' * sender of the transaction and its data. While these are generally available\n', ' * via msg.sender and msg.data, they should not be accessed in such a direct\n', ' * manner, since when dealing with GSN meta-transactions the account sending and\n', ' * paying for execution may not be the actual sender (as far as an application\n', ' * is concerned).\n', ' *\n', ' * This contract is only required for intermediate, library-like contracts.\n', ' */\n', 'contract ContextUpgradeSafe is Initializable {\n', '    // Empty internal constructor, to prevent people from mistakenly deploying\n', '    // an instance of this contract, which should be used via inheritance.\n', '\n', '    function __Context_init() internal initializer {\n', '        __Context_init_unchained();\n', '    }\n', '\n', '    function __Context_init_unchained() internal initializer {\n', '\n', '\n', '    }\n', '\n', '\n', '    function _msgSender() internal view virtual returns (address payable) {\n', '        return msg.sender;\n', '    }\n', '\n', '    function _msgData() internal view virtual returns (bytes memory) {\n', '        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691\n', '        return msg.data;\n', '    }\n', '\n', '    uint256[50] private __gap;\n', '}\n', '\n', 'pragma solidity >=0.4.24 <0.7.0;\n', '\n', '\n', '/**\n', ' * @title Initializable\n', ' *\n', ' * @dev Helper contract to support initializer functions. To use it, replace\n', ' * the constructor with a function that has the `initializer` modifier.\n', ' * WARNING: Unlike constructors, initializer functions must be manually\n', ' * invoked. This applies both to deploying an Initializable contract, as well\n', ' * as extending an Initializable contract via inheritance.\n', ' * WARNING: When used with inheritance, manual care must be taken to not invoke\n', ' * a parent initializer twice, or ensure that all initializers are idempotent,\n', ' * because this is not dealt with automatically as with constructors.\n', ' */\n', 'contract Initializable {\n', '\n', '  /**\n', '   * @dev Indicates that the contract has been initialized.\n', '   */\n', '  bool private initialized;\n', '\n', '  /**\n', '   * @dev Indicates that the contract is in the process of being initialized.\n', '   */\n', '  bool private initializing;\n', '\n', '  /**\n', '   * @dev Modifier to use in the initializer function of a contract.\n', '   */\n', '  modifier initializer() {\n', '    require(initializing || isConstructor() || !initialized, "Contract instance has already been initialized");\n', '\n', '    bool isTopLevelCall = !initializing;\n', '    if (isTopLevelCall) {\n', '      initializing = true;\n', '      initialized = true;\n', '    }\n', '\n', '    _;\n', '\n', '    if (isTopLevelCall) {\n', '      initializing = false;\n', '    }\n', '  }\n', '\n', '  /// @dev Returns true if and only if the function is running in the constructor\n', '  function isConstructor() private view returns (bool) {\n', '    // extcodesize checks the size of the code stored in an address, and\n', '    // address returns the current address. Since the code is still not\n', '    // deployed when running a constructor, any checks on its code size will\n', '    // yield zero, making it an effective way to detect if a contract is\n', '    // under construction or not.\n', '    address self = address(this);\n', '    uint256 cs;\n', '    assembly { cs := extcodesize(self) }\n', '    return cs == 0;\n', '  }\n', '\n', '  // Reserved storage space to allow for layout changes in the future.\n', '  uint256[50] private ______gap;\n', '}\n', '\n', '{\n', '  "metadata": {\n', '    "useLiteralContent": true\n', '  },\n', '  "optimizer": {\n', '    "enabled": true,\n', '    "runs": 200\n', '  },\n', '  "outputSelection": {\n', '    "*": {\n', '      "*": [\n', '        "evm.bytecode",\n', '        "evm.deployedBytecode",\n', '        "abi"\n', '      ]\n', '    }\n', '  }\n', '}']