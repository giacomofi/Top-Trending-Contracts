['/**\n', ' *Submitted for verification at Etherscan.io on 2021-05-13\n', '*/\n', '\n', '/*\n', '   ____            __   __        __   _\n', '  / __/__ __ ___  / /_ / /  ___  / /_ (_)__ __\n', ' _\\ \\ / // // _ \\/ __// _ \\/ -_)/ __// / \\ \\ /\n', '/___/ \\_, //_//_/\\__//_//_/\\__/ \\__//_/ /_\\_\\\n', '     /___/\n', '\n', '* Synthetix: NativeEtherWrapper.sol\n', '*\n', '* Latest source (may be newer): https://github.com/Synthetixio/synthetix/blob/master/contracts/NativeEtherWrapper.sol\n', '* Docs: https://docs.synthetix.io/contracts/NativeEtherWrapper\n', '*\n', '* Contract Dependencies: \n', '*\t- IAddressResolver\n', '*\t- MixinResolver\n', '*\t- Owned\n', '* Libraries: (none)\n', '*\n', '* MIT License\n', '* ===========\n', '*\n', '* Copyright (c) 2021 Synthetix\n', '*\n', '* Permission is hereby granted, free of charge, to any person obtaining a copy\n', '* of this software and associated documentation files (the "Software"), to deal\n', '* in the Software without restriction, including without limitation the rights\n', '* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell\n', '* copies of the Software, and to permit persons to whom the Software is\n', '* furnished to do so, subject to the following conditions:\n', '*\n', '* The above copyright notice and this permission notice shall be included in all\n', '* copies or substantial portions of the Software.\n', '*\n', '* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR\n', '* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,\n', '* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE\n', '* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER\n', '* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,\n', '* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE\n', '*/\n', '\n', '\n', '\n', 'pragma solidity ^0.5.16;\n', '\n', '// https://docs.synthetix.io/contracts/source/contracts/owned\n', 'contract Owned {\n', '    address public owner;\n', '    address public nominatedOwner;\n', '\n', '    constructor(address _owner) public {\n', '        require(_owner != address(0), "Owner address cannot be 0");\n', '        owner = _owner;\n', '        emit OwnerChanged(address(0), _owner);\n', '    }\n', '\n', '    function nominateNewOwner(address _owner) external onlyOwner {\n', '        nominatedOwner = _owner;\n', '        emit OwnerNominated(_owner);\n', '    }\n', '\n', '    function acceptOwnership() external {\n', '        require(msg.sender == nominatedOwner, "You must be nominated before you can accept ownership");\n', '        emit OwnerChanged(owner, nominatedOwner);\n', '        owner = nominatedOwner;\n', '        nominatedOwner = address(0);\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        _onlyOwner();\n', '        _;\n', '    }\n', '\n', '    function _onlyOwner() private view {\n', '        require(msg.sender == owner, "Only the contract owner may perform this action");\n', '    }\n', '\n', '    event OwnerNominated(address newOwner);\n', '    event OwnerChanged(address oldOwner, address newOwner);\n', '}\n', '\n', '\n', '// https://docs.synthetix.io/contracts/source/interfaces/iaddressresolver\n', 'interface IAddressResolver {\n', '    function getAddress(bytes32 name) external view returns (address);\n', '\n', '    function getSynth(bytes32 key) external view returns (address);\n', '\n', '    function requireAndGetAddress(bytes32 name, string calldata reason) external view returns (address);\n', '}\n', '\n', '\n', 'interface IWETH {\n', '    // ERC20 Optional Views\n', '    function name() external view returns (string memory);\n', '\n', '    function symbol() external view returns (string memory);\n', '\n', '    function decimals() external view returns (uint8);\n', '\n', '    // Views\n', '    function totalSupply() external view returns (uint);\n', '\n', '    function balanceOf(address owner) external view returns (uint);\n', '\n', '    function allowance(address owner, address spender) external view returns (uint);\n', '\n', '    // Mutative functions\n', '    function transfer(address to, uint value) external returns (bool);\n', '\n', '    function approve(address spender, uint value) external returns (bool);\n', '\n', '    function transferFrom(\n', '        address from,\n', '        address to,\n', '        uint value\n', '    ) external returns (bool);\n', '\n', '    // WETH-specific functions.\n', '    function deposit() external payable;\n', '\n', '    function withdraw(uint amount) external;\n', '\n', '    // Events\n', '    event Transfer(address indexed from, address indexed to, uint value);\n', '    event Approval(address indexed owner, address indexed spender, uint value);\n', '    event Deposit(address indexed to, uint amount);\n', '    event Withdrawal(address indexed to, uint amount);\n', '}\n', '\n', '\n', '// https://docs.synthetix.io/contracts/source/interfaces/ietherwrapper\n', 'contract IEtherWrapper {\n', '    function mint(uint amount) external;\n', '\n', '    function burn(uint amount) external;\n', '\n', '    function distributeFees() external;\n', '\n', '    function capacity() external view returns (uint);\n', '\n', '    function getReserves() external view returns (uint);\n', '\n', '    function totalIssuedSynths() external view returns (uint);\n', '\n', '    function calculateMintFee(uint amount) public view returns (uint);\n', '\n', '    function calculateBurnFee(uint amount) public view returns (uint);\n', '\n', '    function maxETH() public view returns (uint256);\n', '\n', '    function mintFeeRate() public view returns (uint256);\n', '\n', '    function burnFeeRate() public view returns (uint256);\n', '\n', '    function weth() public view returns (IWETH);\n', '}\n', '\n', '\n', '// https://docs.synthetix.io/contracts/source/interfaces/isynth\n', 'interface ISynth {\n', '    // Views\n', '    function currencyKey() external view returns (bytes32);\n', '\n', '    function transferableSynths(address account) external view returns (uint);\n', '\n', '    // Mutative functions\n', '    function transferAndSettle(address to, uint value) external returns (bool);\n', '\n', '    function transferFromAndSettle(\n', '        address from,\n', '        address to,\n', '        uint value\n', '    ) external returns (bool);\n', '\n', '    // Restricted: used internally to Synthetix\n', '    function burn(address account, uint amount) external;\n', '\n', '    function issue(address account, uint amount) external;\n', '}\n', '\n', '\n', '// https://docs.synthetix.io/contracts/source/interfaces/ierc20\n', 'interface IERC20 {\n', '    // ERC20 Optional Views\n', '    function name() external view returns (string memory);\n', '\n', '    function symbol() external view returns (string memory);\n', '\n', '    function decimals() external view returns (uint8);\n', '\n', '    // Views\n', '    function totalSupply() external view returns (uint);\n', '\n', '    function balanceOf(address owner) external view returns (uint);\n', '\n', '    function allowance(address owner, address spender) external view returns (uint);\n', '\n', '    // Mutative functions\n', '    function transfer(address to, uint value) external returns (bool);\n', '\n', '    function approve(address spender, uint value) external returns (bool);\n', '\n', '    function transferFrom(\n', '        address from,\n', '        address to,\n', '        uint value\n', '    ) external returns (bool);\n', '\n', '    // Events\n', '    event Transfer(address indexed from, address indexed to, uint value);\n', '\n', '    event Approval(address indexed owner, address indexed spender, uint value);\n', '}\n', '\n', '\n', '// https://docs.synthetix.io/contracts/source/interfaces/iissuer\n', 'interface IIssuer {\n', '    // Views\n', '    function anySynthOrSNXRateIsInvalid() external view returns (bool anyRateInvalid);\n', '\n', '    function availableCurrencyKeys() external view returns (bytes32[] memory);\n', '\n', '    function availableSynthCount() external view returns (uint);\n', '\n', '    function availableSynths(uint index) external view returns (ISynth);\n', '\n', '    function canBurnSynths(address account) external view returns (bool);\n', '\n', '    function collateral(address account) external view returns (uint);\n', '\n', '    function collateralisationRatio(address issuer) external view returns (uint);\n', '\n', '    function collateralisationRatioAndAnyRatesInvalid(address _issuer)\n', '        external\n', '        view\n', '        returns (uint cratio, bool anyRateIsInvalid);\n', '\n', '    function debtBalanceOf(address issuer, bytes32 currencyKey) external view returns (uint debtBalance);\n', '\n', '    function issuanceRatio() external view returns (uint);\n', '\n', '    function lastIssueEvent(address account) external view returns (uint);\n', '\n', '    function maxIssuableSynths(address issuer) external view returns (uint maxIssuable);\n', '\n', '    function minimumStakeTime() external view returns (uint);\n', '\n', '    function remainingIssuableSynths(address issuer)\n', '        external\n', '        view\n', '        returns (\n', '            uint maxIssuable,\n', '            uint alreadyIssued,\n', '            uint totalSystemDebt\n', '        );\n', '\n', '    function synths(bytes32 currencyKey) external view returns (ISynth);\n', '\n', '    function getSynths(bytes32[] calldata currencyKeys) external view returns (ISynth[] memory);\n', '\n', '    function synthsByAddress(address synthAddress) external view returns (bytes32);\n', '\n', '    function totalIssuedSynths(bytes32 currencyKey, bool excludeEtherCollateral) external view returns (uint);\n', '\n', '    function transferableSynthetixAndAnyRateIsInvalid(address account, uint balance)\n', '        external\n', '        view\n', '        returns (uint transferable, bool anyRateIsInvalid);\n', '\n', '    // Restricted: used internally to Synthetix\n', '    function issueSynths(address from, uint amount) external;\n', '\n', '    function issueSynthsOnBehalf(\n', '        address issueFor,\n', '        address from,\n', '        uint amount\n', '    ) external;\n', '\n', '    function issueMaxSynths(address from) external;\n', '\n', '    function issueMaxSynthsOnBehalf(address issueFor, address from) external;\n', '\n', '    function burnSynths(address from, uint amount) external;\n', '\n', '    function burnSynthsOnBehalf(\n', '        address burnForAddress,\n', '        address from,\n', '        uint amount\n', '    ) external;\n', '\n', '    function burnSynthsToTarget(address from) external;\n', '\n', '    function burnSynthsToTargetOnBehalf(address burnForAddress, address from) external;\n', '\n', '    function liquidateDelinquentAccount(\n', '        address account,\n', '        uint susdAmount,\n', '        address liquidator\n', '    ) external returns (uint totalRedeemed, uint amountToLiquidate);\n', '}\n', '\n', '\n', '// Inheritance\n', '\n', '\n', '// Internal references\n', '\n', '\n', '// https://docs.synthetix.io/contracts/source/contracts/addressresolver\n', 'contract AddressResolver is Owned, IAddressResolver {\n', '    mapping(bytes32 => address) public repository;\n', '\n', '    constructor(address _owner) public Owned(_owner) {}\n', '\n', '    /* ========== RESTRICTED FUNCTIONS ========== */\n', '\n', '    function importAddresses(bytes32[] calldata names, address[] calldata destinations) external onlyOwner {\n', '        require(names.length == destinations.length, "Input lengths must match");\n', '\n', '        for (uint i = 0; i < names.length; i++) {\n', '            bytes32 name = names[i];\n', '            address destination = destinations[i];\n', '            repository[name] = destination;\n', '            emit AddressImported(name, destination);\n', '        }\n', '    }\n', '\n', '    /* ========= PUBLIC FUNCTIONS ========== */\n', '\n', '    function rebuildCaches(MixinResolver[] calldata destinations) external {\n', '        for (uint i = 0; i < destinations.length; i++) {\n', '            destinations[i].rebuildCache();\n', '        }\n', '    }\n', '\n', '    /* ========== VIEWS ========== */\n', '\n', '    function areAddressesImported(bytes32[] calldata names, address[] calldata destinations) external view returns (bool) {\n', '        for (uint i = 0; i < names.length; i++) {\n', '            if (repository[names[i]] != destinations[i]) {\n', '                return false;\n', '            }\n', '        }\n', '        return true;\n', '    }\n', '\n', '    function getAddress(bytes32 name) external view returns (address) {\n', '        return repository[name];\n', '    }\n', '\n', '    function requireAndGetAddress(bytes32 name, string calldata reason) external view returns (address) {\n', '        address _foundAddress = repository[name];\n', '        require(_foundAddress != address(0), reason);\n', '        return _foundAddress;\n', '    }\n', '\n', '    function getSynth(bytes32 key) external view returns (address) {\n', '        IIssuer issuer = IIssuer(repository["Issuer"]);\n', '        require(address(issuer) != address(0), "Cannot find Issuer address");\n', '        return address(issuer.synths(key));\n', '    }\n', '\n', '    /* ========== EVENTS ========== */\n', '\n', '    event AddressImported(bytes32 name, address destination);\n', '}\n', '\n', '\n', '// solhint-disable payable-fallback\n', '\n', '// https://docs.synthetix.io/contracts/source/contracts/readproxy\n', 'contract ReadProxy is Owned {\n', '    address public target;\n', '\n', '    constructor(address _owner) public Owned(_owner) {}\n', '\n', '    function setTarget(address _target) external onlyOwner {\n', '        target = _target;\n', '        emit TargetUpdated(target);\n', '    }\n', '\n', '    function() external {\n', '        // The basics of a proxy read call\n', '        // Note that msg.sender in the underlying will always be the address of this contract.\n', '        assembly {\n', '            calldatacopy(0, 0, calldatasize)\n', '\n', '            // Use of staticcall - this will revert if the underlying function mutates state\n', '            let result := staticcall(gas, sload(target_slot), 0, calldatasize, 0, 0)\n', '            returndatacopy(0, 0, returndatasize)\n', '\n', '            if iszero(result) {\n', '                revert(0, returndatasize)\n', '            }\n', '            return(0, returndatasize)\n', '        }\n', '    }\n', '\n', '    event TargetUpdated(address newTarget);\n', '}\n', '\n', '\n', '// Inheritance\n', '\n', '\n', '// Internal references\n', '\n', '\n', '// https://docs.synthetix.io/contracts/source/contracts/mixinresolver\n', 'contract MixinResolver {\n', '    AddressResolver public resolver;\n', '\n', '    mapping(bytes32 => address) private addressCache;\n', '\n', '    constructor(address _resolver) internal {\n', '        resolver = AddressResolver(_resolver);\n', '    }\n', '\n', '    /* ========== INTERNAL FUNCTIONS ========== */\n', '\n', '    function combineArrays(bytes32[] memory first, bytes32[] memory second)\n', '        internal\n', '        pure\n', '        returns (bytes32[] memory combination)\n', '    {\n', '        combination = new bytes32[](first.length + second.length);\n', '\n', '        for (uint i = 0; i < first.length; i++) {\n', '            combination[i] = first[i];\n', '        }\n', '\n', '        for (uint j = 0; j < second.length; j++) {\n', '            combination[first.length + j] = second[j];\n', '        }\n', '    }\n', '\n', '    /* ========== PUBLIC FUNCTIONS ========== */\n', '\n', '    // Note: this function is public not external in order for it to be overridden and invoked via super in subclasses\n', '    function resolverAddressesRequired() public view returns (bytes32[] memory addresses) {}\n', '\n', '    function rebuildCache() public {\n', '        bytes32[] memory requiredAddresses = resolverAddressesRequired();\n', '        // The resolver must call this function whenver it updates its state\n', '        for (uint i = 0; i < requiredAddresses.length; i++) {\n', '            bytes32 name = requiredAddresses[i];\n', '            // Note: can only be invoked once the resolver has all the targets needed added\n', '            address destination =\n', '                resolver.requireAndGetAddress(name, string(abi.encodePacked("Resolver missing target: ", name)));\n', '            addressCache[name] = destination;\n', '            emit CacheUpdated(name, destination);\n', '        }\n', '    }\n', '\n', '    /* ========== VIEWS ========== */\n', '\n', '    function isResolverCached() external view returns (bool) {\n', '        bytes32[] memory requiredAddresses = resolverAddressesRequired();\n', '        for (uint i = 0; i < requiredAddresses.length; i++) {\n', '            bytes32 name = requiredAddresses[i];\n', "            // false if our cache is invalid or if the resolver doesn't have the required address\n", '            if (resolver.getAddress(name) != addressCache[name] || addressCache[name] == address(0)) {\n', '                return false;\n', '            }\n', '        }\n', '\n', '        return true;\n', '    }\n', '\n', '    /* ========== INTERNAL FUNCTIONS ========== */\n', '\n', '    function requireAndGetAddress(bytes32 name) internal view returns (address) {\n', '        address _foundAddress = addressCache[name];\n', '        require(_foundAddress != address(0), string(abi.encodePacked("Missing address: ", name)));\n', '        return _foundAddress;\n', '    }\n', '\n', '    /* ========== EVENTS ========== */\n', '\n', '    event CacheUpdated(bytes32 name, address destination);\n', '}\n', '\n', '\n', '// @unsupported: ovm\n', '\n', '\n', '// Inheritance\n', '\n', '\n', '// Internal references\n', '\n', '\n', '// https://docs.synthetix.io/contracts/source/contracts/nativeetherwrapper\n', 'contract NativeEtherWrapper is Owned, MixinResolver {\n', '    bytes32 private constant CONTRACT_ETHER_WRAPPER = "EtherWrapper";\n', '    bytes32 private constant CONTRACT_SYNTHSETH = "SynthsETH";\n', '\n', '    constructor(address _owner, address _resolver) public Owned(_owner) MixinResolver(_resolver) {}\n', '\n', '    /* ========== PUBLIC FUNCTIONS ========== */\n', '\n', '    /* ========== VIEWS ========== */\n', '    function resolverAddressesRequired() public view returns (bytes32[] memory addresses) {\n', '        bytes32[] memory addresses = new bytes32[](2);\n', '        addresses[0] = CONTRACT_ETHER_WRAPPER;\n', '        addresses[1] = CONTRACT_SYNTHSETH;\n', '        return addresses;\n', '    }\n', '\n', '    function etherWrapper() internal view returns (IEtherWrapper) {\n', '        return IEtherWrapper(requireAndGetAddress(CONTRACT_ETHER_WRAPPER));\n', '    }\n', '\n', '    function weth() internal view returns (IWETH) {\n', '        return etherWrapper().weth();\n', '    }\n', '\n', '    function synthsETH() internal view returns (IERC20) {\n', '        return IERC20(requireAndGetAddress(CONTRACT_SYNTHSETH));\n', '    }\n', '\n', '    /* ========== MUTATIVE FUNCTIONS ========== */\n', '\n', '    function mint() public payable {\n', '        uint amount = msg.value;\n', '        require(amount > 0, "msg.value must be greater than 0");\n', '\n', '        // Convert sent ETH into WETH.\n', '        weth().deposit.value(amount)();\n', '\n', '        // Approve for the EtherWrapper.\n', '        weth().approve(address(etherWrapper()), amount);\n', '\n', '        // Now call mint.\n', '        etherWrapper().mint(amount);\n', '\n', '        // Transfer the sETH to msg.sender.\n', '        synthsETH().transfer(msg.sender, synthsETH().balanceOf(address(this)));\n', '\n', '        emit Minted(msg.sender, amount);\n', '    }\n', '\n', '    function burn(uint amount) public {\n', '        require(amount > 0, "amount must be greater than 0");\n', '        IWETH weth = weth();\n', '\n', '        // Transfer sETH from the msg.sender.\n', '        synthsETH().transferFrom(msg.sender, address(this), amount);\n', '\n', '        // Approve for the EtherWrapper.\n', '        synthsETH().approve(address(etherWrapper()), amount);\n', '\n', '        // Now call burn.\n', '        etherWrapper().burn(amount);\n', '\n', '        // Convert WETH to ETH and send to msg.sender.\n', '        weth.withdraw(weth.balanceOf(address(this)));\n', '        // solhint-disable avoid-low-level-calls\n', '        msg.sender.call.value(address(this).balance)("");\n', '\n', '        emit Burned(msg.sender, amount);\n', '    }\n', '\n', '    function() external payable {\n', '        // Allow the WETH contract to send us ETH during\n', '        // our call to WETH.deposit. The gas stipend it gives\n', "        // is 2300 gas, so it's not possible to do much else here.\n", '    }\n', '\n', '    /* ========== EVENTS ========== */\n', '    // While these events are replicated in the core EtherWrapper,\n', '    // it is useful to see the usage of the NativeEtherWrapper contract.\n', '    event Minted(address indexed account, uint amount);\n', '    event Burned(address indexed account, uint amount);\n', '}']