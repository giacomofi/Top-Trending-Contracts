['pragma solidity ^0.6.0;\n', '\n', 'interface TokenInterface {\n', '    function approve(address, uint) external;\n', '    function transfer(address, uint) external;\n', '    function deposit() external payable;\n', '    function withdraw(uint) external;\n', '    function balanceOf(address) external view returns (uint);\n', '}\n', '\n', 'interface ManagerLike {\n', '    function cdpCan(address, uint, address) external view returns (uint);\n', '    function ilks(uint) external view returns (bytes32);\n', '    function last(address) external view returns (uint);\n', '    function count(address) external view returns (uint);\n', '    function owns(uint) external view returns (address);\n', '    function urns(uint) external view returns (address);\n', '    function vat() external view returns (address);\n', '    function open(bytes32, address) external returns (uint);\n', '    function give(uint, address) external;\n', '    function frob(uint, int, int) external;\n', '    function flux(uint, address, uint) external;\n', '    function move(uint, address, uint) external;\n', '}\n', '\n', 'interface VatLike {\n', '    function can(address, address) external view returns (uint);\n', '    function ilks(bytes32) external view returns (uint, uint, uint, uint, uint);\n', '    function dai(address) external view returns (uint);\n', '    function urns(bytes32, address) external view returns (uint, uint);\n', '    function frob(\n', '        bytes32,\n', '        address,\n', '        address,\n', '        address,\n', '        int,\n', '        int\n', '    ) external;\n', '    function hope(address) external;\n', '    function move(address, address, uint) external;\n', '    function gem(bytes32, address) external view returns (uint);\n', '}\n', '\n', 'interface TokenJoinInterface {\n', '    function dec() external returns (uint);\n', '    function gem() external returns (TokenInterface);\n', '    function join(address, uint) external payable;\n', '    function exit(address, uint) external;\n', '}\n', '\n', 'interface DaiJoinInterface {\n', '    function vat() external returns (VatLike);\n', '    function dai() external returns (TokenInterface);\n', '    function join(address, uint) external payable;\n', '    function exit(address, uint) external;\n', '}\n', '\n', 'interface JugLike {\n', '    function drip(bytes32) external returns (uint);\n', '}\n', '\n', 'interface PotLike {\n', '    function pie(address) external view returns (uint);\n', '    function drip() external returns (uint);\n', '    function join(uint) external;\n', '    function exit(uint) external;\n', '}\n', '\n', 'interface MemoryInterface {\n', '    function getUint(uint _id) external returns (uint _num);\n', '    function setUint(uint _id, uint _val) external;\n', '}\n', '\n', 'interface InstaMapping {\n', '    function gemJoinMapping(bytes32) external view returns (address);\n', '}\n', '\n', 'interface EventInterface {\n', '    function emitEvent(uint _connectorType, uint _connectorID, bytes32 _eventCode, bytes calldata _eventData) external;\n', '}\n', '\n', 'interface AccountInterface {\n', '    function isAuth(address _user) external view returns (bool);\n', '}\n', '\n', 'contract DSMath {\n', '\n', '    uint256 constant RAY = 10 ** 27;\n', '    uint constant WAD = 10 ** 18;\n', '\n', '    function add(uint x, uint y) internal pure returns (uint z) {\n', '        require((z = x + y) >= x, "math-not-safe");\n', '    }\n', '\n', '    function sub(uint x, uint y) internal pure returns (uint z) {\n', '        require((z = x - y) <= x, "sub-overflow");\n', '    }\n', '\n', '    function mul(uint x, uint y) internal pure returns (uint z) {\n', '        require(y == 0 || (z = x * y) / y == x, "math-not-safe");\n', '    }\n', '\n', '    function wmul(uint x, uint y) internal pure returns (uint z) {\n', '        z = add(mul(x, y), WAD / 2) / WAD;\n', '    }\n', '\n', '    function wdiv(uint x, uint y) internal pure returns (uint z) {\n', '        z = add(mul(x, WAD), y / 2) / y;\n', '    }\n', '\n', '    function rdiv(uint x, uint y) internal pure returns (uint z) {\n', '        z = add(mul(x, RAY), y / 2) / y;\n', '    }\n', '\n', '    function rmul(uint x, uint y) internal pure returns (uint z) {\n', '        z = add(mul(x, y), RAY / 2) / RAY;\n', '    }\n', '\n', '    function toInt(uint x) internal pure returns (int y) {\n', '        y = int(x);\n', '        require(y >= 0, "int-overflow");\n', '    }\n', '\n', '    function toRad(uint wad) internal pure returns (uint rad) {\n', '        rad = mul(wad, 10 ** 27);\n', '    }\n', '\n', '    function convertTo18(uint _dec, uint256 _amt) internal pure returns (uint256 amt) {\n', '        amt = mul(_amt, 10 ** (18 - _dec));\n', '    }\n', '\n', '    function convert18ToDec(uint _dec, uint256 _amt) internal pure returns (uint256 amt) {\n', '        amt = (_amt / 10 ** (18 - _dec));\n', '    }\n', '}\n', '\n', '\n', 'contract Helpers is DSMath {\n', '    /**\n', '     * @dev Return ETH Address.\n', '     */\n', '    function getAddressETH() internal pure returns (address) {\n', '        return 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;\n', '    }\n', '\n', '    /**\n', '     * @dev Return WETH Address.\n', '     */\n', '    function getAddressWETH() internal pure returns (address) {\n', '        return 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;\n', '    }\n', '\n', '    /**\n', '     * @dev Return InstAaMemory Address.\n', '     */\n', '    function getMemoryAddr() internal pure returns (address) {\n', '        return 0x8a5419CfC711B2343c17a6ABf4B2bAFaBb06957F;\n', '    }\n', '\n', '    /**\n', '     * @dev Return InstaEvent Address.\n', '     */\n', '    function getEventAddr() internal pure returns (address) {\n', '        return 0x2af7ea6Cb911035f3eb1ED895Cb6692C39ecbA97;\n', '    }\n', '\n', '    /**\n', '     * @dev Get Uint value from InstaMemory Contract.\n', '    */\n', '    function getUint(uint getId, uint val) internal returns (uint returnVal) {\n', '        returnVal = getId == 0 ? val : MemoryInterface(getMemoryAddr()).getUint(getId);\n', '    }\n', '\n', '    /**\n', '     * @dev Set Uint value in InstaMemory Contract.\n', '    */\n', '    function setUint(uint setId, uint val) internal {\n', '        if (setId != 0) MemoryInterface(getMemoryAddr()).setUint(setId, val);\n', '    }\n', '\n', '    /**\n', '     * @dev emit event on event contract\n', '     */\n', '    function emitEvent(bytes32 eventCode, bytes memory eventData) internal {\n', '        (uint model, uint id) = connectorID();\n', '        EventInterface(getEventAddr()).emitEvent(model, id, eventCode, eventData);\n', '    }\n', '\n', '    /**\n', '     * @dev Connector Details\n', '    */\n', '    function connectorID() public pure returns(uint _type, uint _id) {\n', '        (_type, _id) = (1, 40);\n', '    }\n', '}\n', '\n', '\n', 'contract MakerMCDAddresses is Helpers {\n', '    /**\n', '     * @dev Return Maker MCD Manager Address.\n', '    */\n', '    function getMcdManager() internal pure returns (address) {\n', '        return 0x5ef30b9986345249bc32d8928B7ee64DE9435E39;\n', '    }\n', '\n', '    /**\n', '     * @dev Return Maker MCD DAI Address.\n', '    */\n', '    function getMcdDai() internal pure returns (address) {\n', '        return 0x6B175474E89094C44Da98b954EedeAC495271d0F;\n', '    }\n', '\n', '    /**\n', '     * @dev Return Maker MCD DAI_Join Address.\n', '    */\n', '    function getMcdDaiJoin() internal pure returns (address) {\n', '        return 0x9759A6Ac90977b93B58547b4A71c78317f391A28;\n', '    }\n', '\n', '    /**\n', '     * @dev Return Maker MCD Jug Address.\n', '    */\n', '    function getMcdJug() internal pure returns (address) {\n', '        return 0x19c0976f590D67707E62397C87829d896Dc0f1F1;\n', '    }\n', '\n', '    /**\n', '     * @dev Return Maker MCD Pot Address.\n', '    */\n', '    function getMcdPot() internal pure returns (address) {\n', '        return 0x197E90f9FAD81970bA7976f33CbD77088E5D7cf7;\n', '    }\n', '}\n', '\n', 'contract MakerHelpers is MakerMCDAddresses {\n', '    /**\n', '     * @dev Return InstaMapping Address.\n', '     */\n', '    function getMappingAddr() internal pure returns (address) {\n', '        return 0xe81F70Cc7C0D46e12d70efc60607F16bbD617E88;\n', '    }\n', '\n', '    /**\n', '     * @dev Return Close Vault Address.\n', '    */\n', '    function getGiveAddress() internal pure returns (address) {\n', '        return 0x4dD58550eb15190a5B3DfAE28BB14EeC181fC267;\n', '    }\n', '\n', '    /**\n', "     * @dev Get Vault's ilk.\n", '    */\n', '    function getVaultData(ManagerLike managerContract, uint vault) internal view returns (bytes32 ilk, address urn) {\n', '        ilk = managerContract.ilks(vault);\n', '        urn = managerContract.urns(vault);\n', '    }\n', '\n', '    /**\n', '     * @dev Gem Join address is ETH type collateral.\n', '    */\n', '    function isEth(address tknAddr) internal pure returns (bool) {\n', '        return tknAddr == getAddressWETH() ? true : false;\n', '    }\n', '\n', '    /**\n', '     * @dev Get Vault Debt Amount.\n', '    */\n', '    function _getVaultDebt(\n', '        address vat,\n', '        bytes32 ilk,\n', '        address urn\n', '    ) internal view returns (uint wad) {\n', '        (, uint rate,,,) = VatLike(vat).ilks(ilk);\n', '        (, uint art) = VatLike(vat).urns(ilk, urn);\n', '        uint dai = VatLike(vat).dai(urn);\n', '\n', '        uint rad = sub(mul(art, rate), dai);\n', '        wad = rad / RAY;\n', '\n', '        wad = mul(wad, RAY) < rad ? wad + 1 : wad;\n', '    }\n', '\n', '    /**\n', '     * @dev Get Borrow Amount.\n', '    */\n', '    function _getBorrowAmt(\n', '        address vat,\n', '        address urn,\n', '        bytes32 ilk,\n', '        uint amt\n', '    ) internal returns (int dart)\n', '    {\n', '        address jug = getMcdJug();\n', '        uint rate = JugLike(jug).drip(ilk);\n', '        uint dai = VatLike(vat).dai(urn);\n', '        if (dai < mul(amt, RAY)) {\n', '            dart = toInt(sub(mul(amt, RAY), dai) / rate);\n', '            dart = mul(uint(dart), rate) < mul(amt, RAY) ? dart + 1 : dart;\n', '        }\n', '    }\n', '\n', '    /**\n', '     * @dev Get Payback Amount.\n', '    */\n', '    function _getWipeAmt(\n', '        address vat,\n', '        uint amt,\n', '        address urn,\n', '        bytes32 ilk\n', '    ) internal view returns (int dart)\n', '    {\n', '        (, uint rate,,,) = VatLike(vat).ilks(ilk);\n', '        (, uint art) = VatLike(vat).urns(ilk, urn);\n', '        dart = toInt(amt / rate);\n', '        dart = uint(dart) <= art ? - dart : - toInt(art);\n', '    }\n', '\n', '    /**\n', '     * @dev Convert String to bytes32.\n', '    */\n', '    function stringToBytes32(string memory str) internal pure returns (bytes32 result) {\n', '        require(bytes(str).length != 0, "string-empty");\n', '        // solium-disable-next-line security/no-inline-assembly\n', '        assembly {\n', '            result := mload(add(str, 32))\n', '        }\n', '    }\n', '\n', '    /**\n', '     * @dev Get vault ID. If `vault` is 0, get last opened vault.\n', '    */\n', '    function getVault(ManagerLike managerContract, uint vault) internal view returns (uint _vault) {\n', '        if (vault == 0) {\n', '            require(managerContract.count(address(this)) > 0, "no-vault-opened");\n', '            _vault = managerContract.last(address(this));\n', '        } else {\n', '            _vault = vault;\n', '        }\n', '    }\n', '}\n', '\n', 'contract EventHelper is MakerHelpers {\n', '    event LogOpen(uint256 indexed vault, bytes32 indexed ilk);\n', '    event LogClose(uint256 indexed vault, bytes32 indexed ilk);\n', '    event LogTransfer(uint256 indexed vault, bytes32 indexed ilk, address newOwner);\n', '    event LogDeposit(uint256 indexed vault, bytes32 indexed ilk, uint256 tokenAmt, uint256 getId, uint256 setId);\n', '    event LogWithdraw(uint256 indexed vault, bytes32 indexed ilk, uint256 tokenAmt, uint256 getId, uint256 setId);\n', '    event LogBorrow(uint256 indexed vault, bytes32 indexed ilk, uint256 tokenAmt, uint256 getId, uint256 setId);\n', '    event LogPayback(uint256 indexed vault, bytes32 indexed ilk, uint256 tokenAmt, uint256 getId, uint256 setId);\n', '\n', '    function emitLogDeposit(uint256 vault, bytes32 ilk, uint256 tokenAmt, uint256 getId, uint256 setId) internal {\n', '        emit LogDeposit(vault, ilk, tokenAmt, getId, setId);\n', '        bytes32 _eventCode = keccak256("LogDeposit(uint256,bytes32,uint256,uint256,uint256)");\n', '        bytes memory _eventParam = abi.encode(vault, ilk, tokenAmt, getId, setId);\n', '        emitEvent(_eventCode, _eventParam);\n', '    }\n', '\n', '    function emitLogBorrow(uint256 vault, bytes32 ilk, uint256 tokenAmt, uint256 getId, uint256 setId) internal {\n', '        emit LogBorrow(vault, ilk, tokenAmt, getId, setId);\n', '        bytes32 _eventCode = keccak256("LogBorrow(uint256,bytes32,uint256,uint256,uint256)");\n', '        bytes memory _eventParam = abi.encode(vault, ilk, tokenAmt, getId, setId);\n', '        emitEvent(_eventCode, _eventParam);\n', '    }\n', '}\n', '\n', 'contract BasicResolver is EventHelper {\n', '\n', '    /**\n', '     * @dev Open Vault\n', "     * @param colType Type of Collateral.(eg: 'ETH-A')\n", '    */\n', '    function open(string calldata colType) external payable returns (uint vault) {\n', '        bytes32 ilk = stringToBytes32(colType);\n', '        require(InstaMapping(getMappingAddr()).gemJoinMapping(ilk) != address(0), "wrong-col-type");\n', '        vault = ManagerLike(getMcdManager()).open(ilk, address(this));\n', '\n', '        emit LogOpen(vault, ilk);\n', '        bytes32 _eventCode = keccak256("LogOpen(uint256,bytes32)");\n', '        bytes memory _eventParam = abi.encode(vault, ilk);\n', '        emitEvent(_eventCode, _eventParam);\n', '    }\n', '\n', '    /**\n', '     * @dev Close Vault\n', '     * @param vault Vault ID to close.\n', '    */\n', '    function close(uint vault) external payable {\n', '        ManagerLike managerContract = ManagerLike(getMcdManager());\n', '\n', '        uint _vault = getVault(managerContract, vault);\n', '        (bytes32 ilk, address urn) = getVaultData(managerContract, _vault);\n', '        (uint ink, uint art) = VatLike(managerContract.vat()).urns(ilk, urn);\n', '\n', '        require(ink == 0 && art == 0, "vault-has-assets");\n', '        require(managerContract.owns(_vault) == address(this), "not-owner");\n', '\n', '        managerContract.give(_vault, getGiveAddress());\n', '\n', '        emit LogClose(_vault, ilk);\n', '        bytes32 _eventCode = keccak256("LogClose(uint256,bytes32)");\n', '        bytes memory _eventParam = abi.encode(_vault, ilk);\n', '        emitEvent(_eventCode, _eventParam);\n', '    }\n', '\n', '    /**\n', '     * @dev Deposit ETH/ERC20_Token Collateral.\n', '     * @param vault Vault ID.\n', '     * @param amt token amount to deposit.\n', '     * @param getId Get token amount at this ID from `InstaMemory` Contract.\n', '     * @param setId Set token amount at this ID in `InstaMemory` Contract.\n', '    */\n', '    function deposit(\n', '        uint vault,\n', '        uint amt,\n', '        uint getId,\n', '        uint setId\n', '    ) external payable\n', '    {\n', '        ManagerLike managerContract = ManagerLike(getMcdManager());\n', '\n', '        uint _amt = getUint(getId, amt);\n', '        uint _vault = getVault(managerContract, vault);\n', '        (bytes32 ilk, address urn) = getVaultData(managerContract, _vault);\n', '\n', '        address colAddr = InstaMapping(getMappingAddr()).gemJoinMapping(ilk);\n', '        TokenJoinInterface tokenJoinContract = TokenJoinInterface(colAddr);\n', '        TokenInterface tokenContract = tokenJoinContract.gem();\n', '\n', '        if (isEth(address(tokenContract))) {\n', '            _amt = _amt == uint(-1) ? address(this).balance : _amt;\n', '            tokenContract.deposit.value(_amt)();\n', '        } else {\n', '            _amt = _amt == uint(-1) ?  tokenContract.balanceOf(address(this)) : _amt;\n', '        }\n', '\n', '        tokenContract.approve(address(colAddr), _amt);\n', '        tokenJoinContract.join(address(this), _amt);\n', '\n', '        VatLike(managerContract.vat()).frob(\n', '            ilk,\n', '            urn,\n', '            address(this),\n', '            address(this),\n', '            toInt(convertTo18(tokenJoinContract.dec(), _amt)),\n', '            0\n', '        );\n', '\n', '        setUint(setId, _amt);\n', '\n', '        emitLogDeposit(_vault, ilk, _amt, getId, setId);\n', '    }\n', '\n', '    /**\n', '     * @dev Withdraw ETH/ERC20_Token Collateral.\n', '     * @param vault Vault ID.\n', '     * @param amt token amount to withdraw.\n', '     * @param getId Get token amount at this ID from `InstaMemory` Contract.\n', '     * @param setId Set token amount at this ID in `InstaMemory` Contract.\n', '    */\n', '    function withdraw(\n', '        uint vault,\n', '        uint amt,\n', '        uint getId,\n', '        uint setId\n', '    ) external payable {\n', '        ManagerLike managerContract = ManagerLike(getMcdManager());\n', '\n', '        uint _amt = getUint(getId, amt);\n', '        uint _vault = getVault(managerContract, vault);\n', '        (bytes32 ilk, address urn) = getVaultData(managerContract, _vault);\n', '\n', '        address colAddr = InstaMapping(getMappingAddr()).gemJoinMapping(ilk);\n', '        TokenJoinInterface tokenJoinContract = TokenJoinInterface(colAddr);\n', '\n', '        uint _amt18;\n', '        if (_amt == uint(-1)) {\n', '            (_amt18,) = VatLike(managerContract.vat()).urns(ilk, urn);\n', '            _amt = convert18ToDec(tokenJoinContract.dec(), _amt18);\n', '        } else {\n', '            _amt18 = convertTo18(tokenJoinContract.dec(), _amt);\n', '        }\n', '\n', '        managerContract.frob(\n', '            _vault,\n', '            -toInt(_amt18),\n', '            0\n', '        );\n', '\n', '        managerContract.flux(\n', '            _vault,\n', '            address(this),\n', '            _amt18\n', '        );\n', '\n', '        TokenInterface tokenContract = tokenJoinContract.gem();\n', '\n', '        if (isEth(address(tokenContract))) {\n', '            tokenJoinContract.exit(address(this), _amt);\n', '            tokenContract.withdraw(_amt);\n', '        } else {\n', '            tokenJoinContract.exit(address(this), _amt);\n', '        }\n', '\n', '        setUint(setId, _amt);\n', '\n', '        emit LogWithdraw(_vault, ilk, _amt, getId, setId);\n', '        bytes32 _eventCode = keccak256("LogWithdraw(uint256,bytes32,uint256,uint256,uint256)");\n', '        bytes memory _eventParam = abi.encode(_vault, ilk, _amt, getId, setId);\n', '        emitEvent(_eventCode, _eventParam);\n', '    }\n', '\n', '    /**\n', '     * @dev Borrow DAI.\n', '     * @param vault Vault ID.\n', '     * @param amt token amount to borrow.\n', '     * @param getId Get token amount at this ID from `InstaMemory` Contract.\n', '     * @param setId Set token amount at this ID in `InstaMemory` Contract.\n', '    */\n', '    function borrow(\n', '        uint vault,\n', '        uint amt,\n', '        uint getId,\n', '        uint setId\n', '    ) external payable {\n', '        ManagerLike managerContract = ManagerLike(getMcdManager());\n', '\n', '        uint _amt = getUint(getId, amt);\n', '        uint _vault = getVault(managerContract, vault);\n', '        (bytes32 ilk, address urn) = getVaultData(managerContract, _vault);\n', '\n', '        address daiJoin = getMcdDaiJoin();\n', '\n', '        VatLike vatContract = VatLike(managerContract.vat());\n', '\n', '        managerContract.frob(\n', '            _vault,\n', '            0,\n', '            _getBorrowAmt(\n', '                address(vatContract),\n', '                urn,\n', '                ilk,\n', '                _amt\n', '            )\n', '        );\n', '\n', '        managerContract.move(\n', '            _vault,\n', '            address(this),\n', '            toRad(_amt)\n', '        );\n', '\n', '        if (vatContract.can(address(this), address(daiJoin)) == 0) {\n', '            vatContract.hope(daiJoin);\n', '        }\n', '\n', '        DaiJoinInterface(daiJoin).exit(address(this), _amt);\n', '\n', '        setUint(setId, _amt);\n', '\n', '        emitLogBorrow(_vault, ilk, _amt, getId, setId);\n', '    }\n', '\n', '    /**\n', '     * @dev Payback borrowed DAI.\n', '     * @param vault Vault ID.\n', '     * @param amt token amount to payback.\n', '     * @param getId Get token amount at this ID from `InstaMemory` Contract.\n', '     * @param setId Set token amount at this ID in `InstaMemory` Contract.\n', '    */\n', '    function payback(\n', '        uint vault,\n', '        uint amt,\n', '        uint getId,\n', '        uint setId\n', '    ) external payable {\n', '        ManagerLike managerContract = ManagerLike(getMcdManager());\n', '        uint _amt = getUint(getId, amt);\n', '        uint _vault = getVault(managerContract, vault);\n', '        (bytes32 ilk, address urn) = getVaultData(managerContract, _vault);\n', '\n', '        address vat = managerContract.vat();\n', '\n', '        uint _maxDebt = _getVaultDebt(vat, ilk, urn);\n', '\n', '        _amt = _amt == uint(-1) ? _maxDebt : _amt;\n', '\n', '        require(_maxDebt >= _amt, "paying-excess-debt");\n', '\n', '        DaiJoinInterface daiJoinContract = DaiJoinInterface(getMcdDaiJoin());\n', '        daiJoinContract.dai().approve(getMcdDaiJoin(), _amt);\n', '        daiJoinContract.join(urn, _amt);\n', '\n', '        managerContract.frob(\n', '            _vault,\n', '            0,\n', '            _getWipeAmt(\n', '                vat,\n', '                VatLike(vat).dai(urn),\n', '                urn,\n', '                ilk\n', '            )\n', '        );\n', '\n', '        setUint(setId, _amt);\n', '\n', '        emit LogPayback(_vault, ilk, _amt, getId, setId);\n', '        bytes32 _eventCode = keccak256("LogPayback(uint256,bytes32,uint256,uint256,uint256)");\n', '        bytes memory _eventParam = abi.encode(_vault, ilk, _amt, getId, setId);\n', '        emitEvent(_eventCode, _eventParam);\n', '    }\n', '}\n', '\n', '\n', 'contract BasicExtraResolver is BasicResolver {\n', '    event LogWithdrawLiquidated(uint256 indexed vault, bytes32 indexed ilk, uint256 tokenAmt, uint256 getId, uint256 setId);\n', '    event LogExitDai(uint256 indexed vault, bytes32 indexed ilk, uint256 tokenAmt, uint256 getId, uint256 setId);\n', '\n', '    /**\n', '     * @dev Withdraw leftover ETH/ERC20_Token after Liquidation.\n', '     * @param vault Vault ID.\n', '     * @param amt token amount to Withdraw.\n', '     * @param getId Get token amount at this ID from `InstaMemory` Contract.\n', '     * @param setId Set token amount at this ID in `InstaMemory` Contract.\n', '    */\n', '    function withdrawLiquidated(\n', '        uint vault,\n', '        uint amt,\n', '        uint getId,\n', '        uint setId\n', '    )\n', '    external payable {\n', '        ManagerLike managerContract = ManagerLike(getMcdManager());\n', '\n', '        uint _amt = getUint(getId, amt);\n', '        (bytes32 ilk, address urn) = getVaultData(managerContract, vault);\n', '\n', '        address colAddr = InstaMapping(getMappingAddr()).gemJoinMapping(ilk);\n', '        TokenJoinInterface tokenJoinContract = TokenJoinInterface(colAddr);\n', '\n', '        uint _amt18;\n', '        if (_amt == uint(-1)) {\n', '            _amt18 = VatLike(managerContract.vat()).gem(ilk, urn);\n', '            _amt = convert18ToDec(tokenJoinContract.dec(), _amt);\n', '        } else {\n', '            _amt18 = convertTo18(tokenJoinContract.dec(), _amt);\n', '        }\n', '\n', '        managerContract.flux(\n', '            vault,\n', '            address(this),\n', '            _amt18\n', '        );\n', '\n', '        TokenInterface tokenContract = tokenJoinContract.gem();\n', '        tokenJoinContract.exit(address(this), _amt);\n', '        if (isEth(address(tokenContract))) {\n', '            tokenContract.withdraw(_amt);\n', '        }\n', '\n', '        setUint(setId, _amt);\n', '\n', '        emit LogWithdrawLiquidated(vault, ilk, _amt, getId, setId);\n', '        bytes32 _eventCode = keccak256("LogWithdrawLiquidated(uint256,bytes32,uint256,uint256,uint256)");\n', '        bytes memory _eventParam = abi.encode(vault, ilk, _amt, getId, setId);\n', '        emitEvent(_eventCode, _eventParam);\n', '    }\n', '\n', '    struct MakerData {\n', '        uint _vault;\n', '        address colAddr;\n', '        address daiJoin;\n', '        TokenJoinInterface tokenJoinContract;\n', '        VatLike vatContract;\n', '        TokenInterface tokenContract;\n', '    }\n', '    /**\n', '     * @dev Deposit ETH/ERC20_Token Collateral and Borrow DAI.\n', '     * @param vault Vault ID.\n', '     * @param depositAmt token deposit amount to Withdraw.\n', '     * @param borrowAmt token borrow amount to Withdraw.\n', '     * @param getIdDeposit Get deposit token amount at this ID from `InstaMemory` Contract.\n', '     * @param getIdBorrow Get borrow token amount at this ID from `InstaMemory` Contract.\n', '     * @param setIdDeposit Set deposit token amount at this ID in `InstaMemory` Contract.\n', '     * @param setIdBorrow Set borrow token amount at this ID in `InstaMemory` Contract.\n', '    */\n', '    function depositAndBorrow(\n', '        uint vault,\n', '        uint depositAmt,\n', '        uint borrowAmt,\n', '        uint getIdDeposit,\n', '        uint getIdBorrow,\n', '        uint setIdDeposit,\n', '        uint setIdBorrow\n', '    ) external payable\n', '    {\n', '        ManagerLike managerContract = ManagerLike(getMcdManager());\n', '        MakerData memory makerData;\n', '        uint _amtDeposit = getUint(getIdDeposit, depositAmt);\n', '        uint _amtBorrow = getUint(getIdBorrow, borrowAmt);\n', '\n', '        makerData._vault = getVault(managerContract, vault);\n', '        (bytes32 ilk, address urn) = getVaultData(managerContract, makerData._vault);\n', '\n', '        makerData.colAddr = InstaMapping(getMappingAddr()).gemJoinMapping(ilk);\n', '        makerData.tokenJoinContract = TokenJoinInterface(makerData.colAddr);\n', '        makerData.vatContract = VatLike(managerContract.vat());\n', '        makerData.daiJoin = getMcdDaiJoin();\n', '\n', '        makerData.tokenContract = makerData.tokenJoinContract.gem();\n', '\n', '        if (isEth(address(makerData.tokenContract))) {\n', '            _amtDeposit = _amtDeposit == uint(-1) ? address(this).balance : _amtDeposit;\n', '            makerData.tokenContract.deposit.value(_amtDeposit)();\n', '        } else {\n', '            _amtDeposit = _amtDeposit == uint(-1) ?  makerData.tokenContract.balanceOf(address(this)) : _amtDeposit;\n', '        }\n', '\n', '        makerData.tokenContract.approve(address(makerData.colAddr), _amtDeposit);\n', '        makerData.tokenJoinContract.join(urn, _amtDeposit);\n', '\n', '        managerContract.frob(\n', '            makerData._vault,\n', '            toInt(convertTo18(makerData.tokenJoinContract.dec(), _amtDeposit)),\n', '            _getBorrowAmt(\n', '                address(makerData.vatContract),\n', '                urn,\n', '                ilk,\n', '                _amtBorrow\n', '            )\n', '        );\n', '\n', '        managerContract.move(\n', '            makerData._vault,\n', '            address(this),\n', '            toRad(_amtBorrow)\n', '        );\n', '\n', '        if (makerData.vatContract.can(address(this), address(makerData.daiJoin)) == 0) {\n', '            makerData.vatContract.hope(makerData.daiJoin);\n', '        }\n', '\n', '        DaiJoinInterface(makerData.daiJoin).exit(address(this), _amtBorrow);\n', '\n', '        setUint(setIdDeposit, _amtDeposit);\n', '        setUint(setIdBorrow, _amtBorrow);\n', '\n', '        emitLogDeposit(makerData._vault, ilk, _amtDeposit, getIdDeposit, setIdDeposit);\n', '\n', '        emitLogBorrow(makerData._vault, ilk, _amtBorrow, getIdBorrow, setIdBorrow);\n', '    }\n', '\n', '    /**\n', '     * @dev Exit DAI from urn.\n', '     * @param vault Vault ID.\n', '     * @param amt token amount to exit.\n', '     * @param getId Get token amount at this ID from `InstaMemory` Contract.\n', '     * @param setId Set token amount at this ID in `InstaMemory` Contract.\n', '    */\n', '    function exitDai(\n', '        uint vault,\n', '        uint amt,\n', '        uint getId,\n', '        uint setId\n', '    ) external payable {\n', '        ManagerLike managerContract = ManagerLike(getMcdManager());\n', '\n', '        uint _amt = getUint(getId, amt);\n', '        uint _vault = getVault(managerContract, vault);\n', '        (bytes32 ilk, address urn) = getVaultData(managerContract, _vault);\n', '\n', '        address daiJoin = getMcdDaiJoin();\n', '\n', '        VatLike vatContract = VatLike(managerContract.vat());\n', '        if(_amt == uint(-1)) {\n', '            _amt = vatContract.dai(urn);\n', '            _amt = _amt / 10 ** 27;\n', '        }\n', '\n', '        managerContract.move(\n', '            _vault,\n', '            address(this),\n', '            toRad(_amt)\n', '        );\n', '\n', '        if (vatContract.can(address(this), address(daiJoin)) == 0) {\n', '            vatContract.hope(daiJoin);\n', '        }\n', '\n', '        DaiJoinInterface(daiJoin).exit(address(this), _amt);\n', '\n', '        setUint(setId, _amt);\n', '\n', '        emit LogExitDai(_vault, ilk, _amt, getId, setId);\n', '        bytes32 _eventCode = keccak256("LogExitDai(uint256,bytes32,uint256,uint256,uint256)");\n', '        bytes memory _eventParam = abi.encode(_vault, ilk, _amt, getId, setId);\n', '        (uint _type, uint _id) = connectorID();\n', '        EventInterface(getEventAddr()).emitEvent(_type, _id, _eventCode, _eventParam);\n', '    }\n', '}\n', '\n', 'contract DsrResolver is BasicExtraResolver {\n', '    event LogDepositDai(uint256 tokenAmt, uint256 getId, uint256 setId);\n', '    event LogWithdrawDai(uint256 tokenAmt, uint256 getId, uint256 setId);\n', '\n', '    /**\n', '     * @dev Deposit DAI in DSR.\n', '     * @param amt DAI amount to deposit.\n', '     * @param getId Get token amount at this ID from `InstaMemory` Contract.\n', '     * @param setId Set token amount at this ID in `InstaMemory` Contract.\n', '    */\n', '    function depositDai(\n', '        uint amt,\n', '        uint getId,\n', '        uint setId\n', '    ) external payable {\n', '        uint _amt = getUint(getId, amt);\n', '        address pot = getMcdPot();\n', '        address daiJoin = getMcdDaiJoin();\n', '        DaiJoinInterface daiJoinContract = DaiJoinInterface(daiJoin);\n', '\n', '        _amt = _amt == uint(-1) ?\n', '            daiJoinContract.dai().balanceOf(address(this)) :\n', '            _amt;\n', '\n', '        VatLike vat = daiJoinContract.vat();\n', '        PotLike potContract = PotLike(pot);\n', '\n', '        uint chi = potContract.drip();\n', '\n', '        daiJoinContract.dai().approve(daiJoin, _amt);\n', '        daiJoinContract.join(address(this), _amt);\n', '        if (vat.can(address(this), address(pot)) == 0) {\n', '            vat.hope(pot);\n', '        }\n', '\n', '        potContract.join(mul(_amt, RAY) / chi);\n', '        setUint(setId, _amt);\n', '\n', '        emit LogDepositDai(_amt, getId, setId);\n', '        bytes32 _eventCode = keccak256("LogDepositDai(uint256,uint256,uint256)");\n', '        bytes memory _eventParam = abi.encode(_amt, getId, setId);\n', '        emitEvent(_eventCode, _eventParam);\n', '    }\n', '\n', '    /**\n', '     * @dev Withdraw DAI from DSR.\n', '     * @param amt DAI amount to withdraw.\n', '     * @param getId Get token amount at this ID from `InstaMemory` Contract.\n', '     * @param setId Set token amount at this ID in `InstaMemory` Contract.\n', '    */\n', '    function withdrawDai(\n', '        uint amt,\n', '        uint getId,\n', '        uint setId\n', '    ) external payable {\n', '        address daiJoin = getMcdDaiJoin();\n', '\n', '        uint _amt = getUint(getId, amt);\n', '\n', '        DaiJoinInterface daiJoinContract = DaiJoinInterface(daiJoin);\n', '        VatLike vat = daiJoinContract.vat();\n', '        PotLike potContract = PotLike(getMcdPot());\n', '\n', '        uint chi = potContract.drip();\n', '        uint pie;\n', '        if (_amt == uint(-1)) {\n', '            pie = potContract.pie(address(this));\n', '            _amt = mul(chi, pie) / RAY;\n', '        } else {\n', '            pie = mul(_amt, RAY) / chi;\n', '        }\n', '\n', '        potContract.exit(pie);\n', '\n', '        uint bal = vat.dai(address(this));\n', '        if (vat.can(address(this), address(daiJoin)) == 0) {\n', '            vat.hope(daiJoin);\n', '        }\n', '        daiJoinContract.exit(\n', '            address(this),\n', '            bal >= mul(_amt, RAY) ? _amt : bal / RAY\n', '        );\n', '\n', '        setUint(setId, _amt);\n', '\n', '        emit LogWithdrawDai(_amt, getId, setId);\n', '        bytes32 _eventCode = keccak256("LogWithdrawDai(uint256,uint256,uint256)");\n', '        bytes memory _eventParam = abi.encode(_amt, getId, setId);\n', '        emitEvent(_eventCode, _eventParam);\n', '    }\n', '}\n', '\n', 'contract ConnectMaker is DsrResolver {\n', '    string public constant name = "MakerDao-v1.3";\n', '}']