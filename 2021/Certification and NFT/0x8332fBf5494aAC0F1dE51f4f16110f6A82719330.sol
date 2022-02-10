['/**\n', ' *Submitted for verification at Etherscan.io on 2021-03-05\n', '*/\n', '\n', '// SPDX-License-Identifier: AGPL-3.0-or-later\n', '// Copyright (C) 2021 Maker Ecosystem Growth Holdings, INC.\n', '//\n', '// This program is free software: you can redistribute it and/or modify\n', '// it under the terms of the GNU Affero General Public License as published by\n', '// the Free Software Foundation, either version 3 of the License, or\n', '// (at your option) any later version.\n', '//\n', '// This program is distributed in the hope that it will be useful,\n', '// but WITHOUT ANY WARRANTY; without even the implied warranty of\n', '// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the\n', '// GNU Affero General Public License for more details.\n', '//\n', '// You should have received a copy of the GNU Affero General Public License\n', '// along with this program.  If not, see <https://www.gnu.org/licenses/>.\n', 'pragma solidity 0.6.11;\n', '\n', '// DssExec.sol -- MakerDAO Executive Spell Template\n', '//\n', '// Copyright (C) 2020 Maker Ecosystem Growth Holdings, Inc.\n', '//\n', '// This program is free software: you can redistribute it and/or modify\n', '// it under the terms of the GNU Affero General Public License as published by\n', '// the Free Software Foundation, either version 3 of the License, or\n', '// (at your option) any later version.\n', '//\n', '// This program is distributed in the hope that it will be useful,\n', '// but WITHOUT ANY WARRANTY; without even the implied warranty of\n', '// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the\n', '// GNU Affero General Public License for more details.\n', '//\n', '// You should have received a copy of the GNU Affero General Public License\n', '// along with this program.  If not, see <https://www.gnu.org/licenses/>.\n', '\n', 'interface PauseAbstract {\n', '    function delay() external view returns (uint256);\n', '    function plot(address, bytes32, bytes calldata, uint256) external;\n', '    function exec(address, bytes32, bytes calldata, uint256) external returns (bytes memory);\n', '}\n', '\n', 'interface Changelog {\n', '    function getAddress(bytes32) external view returns (address);\n', '}\n', '\n', 'interface SpellAction {\n', '    function officeHours() external view returns (bool);\n', '}\n', '\n', 'contract DssExec {\n', '\n', '    Changelog      constant public log   = Changelog(0xdA0Ab1e0017DEbCd72Be8599041a2aa3bA7e740F);\n', '    uint256                 public eta;\n', '    bytes                   public sig;\n', '    bool                    public done;\n', '    bytes32       immutable public tag;\n', '    address       immutable public action;\n', '    uint256       immutable public expiration;\n', '    PauseAbstract immutable public pause;\n', '\n', '    // Provides a descriptive tag for bot consumption\n', '    // This should be modified weekly to provide a summary of the actions\n', '    // Hash: seth keccak -- "$(wget https://<executive-vote-canonical-post> -q -O - 2>/dev/null)"\n', '    string                  public description;\n', '\n', '    function officeHours() external view returns (bool) {\n', '        return SpellAction(action).officeHours();\n', '    }\n', '\n', '    function nextCastTime() external view returns (uint256 castTime) {\n', '        require(eta != 0, "DssExec/spell-not-scheduled");\n', '        castTime = block.timestamp > eta ? block.timestamp : eta; // Any day at XX:YY\n', '\n', '        if (SpellAction(action).officeHours()) {\n', '            uint256 day    = (castTime / 1 days + 3) % 7;\n', '            uint256 hour   = castTime / 1 hours % 24;\n', '            uint256 minute = castTime / 1 minutes % 60;\n', '            uint256 second = castTime % 60;\n', '\n', '            if (day >= 5) {\n', '                castTime += (6 - day) * 1 days;                 // Go to Sunday XX:YY\n', '                castTime += (24 - hour + 14) * 1 hours;         // Go to 14:YY UTC Monday\n', '                castTime -= minute * 1 minutes + second;        // Go to 14:00 UTC\n', '            } else {\n', '                if (hour >= 21) {\n', '                    if (day == 4) castTime += 2 days;           // If Friday, fast forward to Sunday XX:YY\n', '                    castTime += (24 - hour + 14) * 1 hours;     // Go to 14:YY UTC next day\n', '                    castTime -= minute * 1 minutes + second;    // Go to 14:00 UTC\n', '                } else if (hour < 14) {\n', '                    castTime += (14 - hour) * 1 hours;          // Go to 14:YY UTC same day\n', '                    castTime -= minute * 1 minutes + second;    // Go to 14:00 UTC\n', '                }\n', '            }\n', '        }\n', '    }\n', '\n', '    // @param _description  A string description of the spell\n', '    // @param _expiration   The timestamp this spell will expire. (Ex. now + 30 days)\n', '    // @param _spellAction  The address of the spell action\n', '    constructor(string memory _description, uint256 _expiration, address _spellAction) public {\n', '        pause       = PauseAbstract(log.getAddress("MCD_PAUSE"));\n', '        description = _description;\n', '        expiration  = _expiration;\n', '        action      = _spellAction;\n', '\n', '        sig = abi.encodeWithSignature("execute()");\n', '        bytes32 _tag;                    // Required for assembly access\n', '        address _action = _spellAction;  // Required for assembly access\n', '        assembly { _tag := extcodehash(_action) }\n', '        tag = _tag;\n', '    }\n', '\n', '    function schedule() public {\n', '        require(now <= expiration, "This contract has expired");\n', '        require(eta == 0, "This spell has already been scheduled");\n', '        eta = now + PauseAbstract(pause).delay();\n', '        pause.plot(action, tag, sig, eta);\n', '    }\n', '\n', '    function cast() public {\n', '        require(!done, "spell-already-cast");\n', '        done = true;\n', '        pause.exec(action, tag, sig, eta);\n', '    }\n', '}\n', '\n', '// DssAction.sol -- DSS Executive Spell Actions\n', '//\n', '// Copyright (C) 2020 Maker Ecosystem Growth Holdings, Inc.\n', '//\n', '// This program is free software: you can redistribute it and/or modify\n', '// it under the terms of the GNU Affero General Public License as published by\n', '// the Free Software Foundation, either version 3 of the License, or\n', '// (at your option) any later version.\n', '//\n', '// This program is distributed in the hope that it will be useful,\n', '// but WITHOUT ANY WARRANTY; without even the implied warranty of\n', '// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the\n', '// GNU Affero General Public License for more details.\n', '//\n', '// You should have received a copy of the GNU Affero General Public License\n', '// along with this program.  If not, see <https://www.gnu.org/licenses/>.\n', '\n', '// DssExecLib.sol -- MakerDAO Executive Spellcrafting Library\n', '//\n', '// Copyright (C) 2020 Maker Ecosystem Growth Holdings, Inc.\n', '//\n', '// This program is free software: you can redistribute it and/or modify\n', '// it under the terms of the GNU Affero General Public License as published by\n', '// the Free Software Foundation, either version 3 of the License, or\n', '// (at your option) any later version.\n', '//\n', '// This program is distributed in the hope that it will be useful,\n', '// but WITHOUT ANY WARRANTY; without even the implied warranty of\n', '// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the\n', '// GNU Affero General Public License for more details.\n', '//\n', '// You should have received a copy of the GNU Affero General Public License\n', '// along with this program.  If not, see <https://www.gnu.org/licenses/>.\n', '\n', 'library DssExecLib {\n', '    function vat()        public view returns (address) {}\n', '    function jug()        public view returns (address) {}\n', '    function spotter()    public view returns (address) {}\n', '    function getChangelogAddress(bytes32) public view returns (address) {}\n', '    function setChangelogAddress(bytes32, address) public {}\n', '    function setChangelogVersion(string memory) public {}\n', '    function authorize(address, address) public {}\n', '    function updateCollateralPrice(bytes32) public {}\n', '    function setContract(address, bytes32, bytes32, address) public {}\n', '    function increaseGlobalDebtCeiling(uint256) public {}\n', '    function setMaxTotalDAILiquidationAmount(uint256) public {}\n', '    function setIlkDebtCeiling(bytes32, uint256) public {}\n', '    function setIlkAutoLineParameters(bytes32, uint256, uint256, uint256) public {}\n', '    function setIlkMinVaultAmount(bytes32, uint256) public {}\n', '    function setIlkLiquidationRatio(bytes32, uint256) public {}\n', '    function setIlkMinAuctionBidIncrease(bytes32, uint256) public {}\n', '    function setIlkBidDuration(bytes32, uint256) public {}\n', '    function setIlkAuctionDuration(bytes32, uint256) public {}\n', '    function setIlkStabilityFee(bytes32, uint256, bool) public {}\n', '}\n', '\n', 'interface OracleLike {\n', '    function src() external view returns (address);\n', '}\n', '\n', 'abstract contract DssAction {\n', '\n', '    using DssExecLib for *;\n', '\n', '    // Office Hours defaults to true by default.\n', '    //   To disable office hours, override this function and\n', '    //    return false in the inherited action.\n', '    function officeHours() public virtual returns (bool) {\n', '        return true;\n', '    }\n', '\n', '    // DssExec calls execute. We limit this function subject to officeHours modifier.\n', '    function execute() external limited {\n', '        actions();\n', '    }\n', '\n', '    // DssAction developer must override `actions()` and place all actions to be called inside.\n', '    //   The DssExec function will call this subject to the officeHours limiter\n', '    //   By keeping this function public we allow simulations of `execute()` on the actions outside of the cast time.\n', '    function actions() public virtual;\n', '\n', '    // Modifier required to\n', '    modifier limited {\n', '        if (officeHours()) {\n', '            uint day = (block.timestamp / 1 days + 3) % 7;\n', '            require(day < 5, "Can only be cast on a weekday");\n', '            uint hour = block.timestamp / 1 hours % 24;\n', '            require(hour >= 14 && hour < 21, "Outside office hours");\n', '        }\n', '        _;\n', '    }\n', '}\n', '\n', 'interface GemJoinAbstract {\n', '    function vat() external view returns (address);\n', '    function ilk() external view returns (bytes32);\n', '    function gem() external view returns (address);\n', '    function dec() external view returns (uint256);\n', '}\n', '\n', 'interface DSTokenAbstract {\n', '    function decimals() external view returns (uint256);\n', '}\n', '\n', 'interface Initializable {\n', '    function init(bytes32) external;\n', '}\n', '\n', 'interface Hopeable {\n', '    function hope(address) external;\n', '}\n', '\n', 'interface Kissable {\n', '    function kiss(address) external;\n', '}\n', '\n', 'interface RwaLiquidationLike {\n', '    function ilks(bytes32) external returns (bytes32,address,uint48,uint48);\n', '    function init(bytes32, uint256, string calldata, uint48) external;\n', '}\n', '\n', 'contract DssSpellAction is DssAction {\n', '\n', '    // Provides a descriptive tag for bot consumption\n', '    // This should be modified weekly to provide a summary of the actions\n', '    // Hash: seth keccak -- "$(wget https://raw.githubusercontent.com/makerdao/community/5925c52da6f8d485447228ca5acd435997522de6/governance/votes/Executive%20vote%20-%20March%205%2C%202021.md -q -O - 2>/dev/null)"\n', '    string public constant description =\n', '        "2021-03-05 MakerDAO Executive Spell | Hash: 0xb9829a5159cc2270de0592c8fcb9f7cbcc79491e26ad7ded78afb7994227f18b";\n', '\n', '\n', '    // Many of the settings that change weekly rely on the rate accumulator\n', '    // described at https://docs.makerdao.com/smart-contract-modules/rates-module\n', '    // To check this yourself, use the following rate calculation (example 8%):\n', '    //\n', "    // $ bc -l <<< 'scale=27; e( l(1.08)/(60 * 60 * 24 * 365) )'\n", '    //\n', '    // A table of rates can be found at\n', '    //    https://ipfs.io/ipfs/QmefQMseb3AiTapiAKKexdKHig8wroKuZbmLtPLv4u2YwW\n', '    //\n', '    uint256 constant THREE_PCT_RATE  = 1000000000937303470807876289;\n', '\n', '    uint256 constant MILLION    = 10**6;\n', '    uint256 constant WAD        = 10**18;\n', '    uint256 constant RAD        = 10**45;\n', '\n', '    address constant RWA001_OPERATOR           = 0x7709f0840097170E5cB1F8c890AcB8601d73b35f;\n', '    address constant RWA001_GEM                = 0x10b2aA5D77Aa6484886d8e244f0686aB319a270d;\n', '    address constant MCD_JOIN_RWA001_A         = 0x476b81c12Dc71EDfad1F64B9E07CaA60F4b156E2;\n', '    address constant RWA001_A_URN              = 0xa3342059BcDcFA57a13b12a35eD4BBE59B873005;\n', '    address constant RWA001_A_INPUT_CONDUIT    = 0x486C85e2bb9801d14f6A8fdb78F5108a0fd932f2;\n', '    address constant RWA001_A_OUTPUT_CONDUIT   = 0xb3eFb912e1cbC0B26FC17388Dd433Cecd2206C3d;\n', '    address constant MIP21_LIQUIDATION_ORACLE  = 0x88f88Bb9E66241B73B84f3A6E197FbBa487b1E30;\n', '    address constant SC_DOMAIN_DEPLOYER_07     = 0xDA0FaB0700A4389F6E6679aBAb1692B4601ce9bf;\n', '\n', '    function actions() public override {\n', '\n', '        // Increase ETH-A target available debt (gap) from 30M to 80M\n', '        DssExecLib.setIlkAutoLineParameters("ETH-A", 2_500 * MILLION, 80 * MILLION, 12 hours);\n', '\n', '        // Decrease the bid duration (ttl) and max auction duration (tau) from 6 to 4 hours to all the ilks with liquidation on\n', '        DssExecLib.setIlkBidDuration("ETH-A", 4 hours);\n', '        DssExecLib.setIlkAuctionDuration("ETH-A", 4 hours);\n', '        DssExecLib.setIlkBidDuration("ETH-B", 4 hours);\n', '        DssExecLib.setIlkAuctionDuration("ETH-B", 4 hours);\n', '        DssExecLib.setIlkBidDuration("BAT-A", 4 hours);\n', '        DssExecLib.setIlkAuctionDuration("BAT-A", 4 hours);\n', '        DssExecLib.setIlkBidDuration("WBTC-A", 4 hours);\n', '        DssExecLib.setIlkAuctionDuration("WBTC-A", 4 hours);\n', '        DssExecLib.setIlkBidDuration("KNC-A", 4 hours);\n', '        DssExecLib.setIlkAuctionDuration("KNC-A", 4 hours);\n', '        DssExecLib.setIlkBidDuration("ZRX-A", 4 hours);\n', '        DssExecLib.setIlkAuctionDuration("ZRX-A", 4 hours);\n', '        DssExecLib.setIlkBidDuration("MANA-A", 4 hours);\n', '        DssExecLib.setIlkAuctionDuration("MANA-A", 4 hours);\n', '        DssExecLib.setIlkBidDuration("USDT-A", 4 hours);\n', '        DssExecLib.setIlkAuctionDuration("USDT-A", 4 hours);\n', '        DssExecLib.setIlkBidDuration("COMP-A", 4 hours);\n', '        DssExecLib.setIlkAuctionDuration("COMP-A", 4 hours);\n', '        DssExecLib.setIlkBidDuration("LRC-A", 4 hours);\n', '        DssExecLib.setIlkAuctionDuration("LRC-A", 4 hours);\n', '        DssExecLib.setIlkBidDuration("LINK-A", 4 hours);\n', '        DssExecLib.setIlkAuctionDuration("LINK-A", 4 hours);\n', '        DssExecLib.setIlkBidDuration("BAL-A", 4 hours);\n', '        DssExecLib.setIlkAuctionDuration("BAL-A", 4 hours);\n', '        DssExecLib.setIlkBidDuration("YFI-A", 4 hours);\n', '        DssExecLib.setIlkAuctionDuration("YFI-A", 4 hours);\n', '        DssExecLib.setIlkBidDuration("UNI-A", 4 hours);\n', '        DssExecLib.setIlkAuctionDuration("UNI-A", 4 hours);\n', '        DssExecLib.setIlkBidDuration("RENBTC-A", 4 hours);\n', '        DssExecLib.setIlkAuctionDuration("RENBTC-A", 4 hours);\n', '        DssExecLib.setIlkBidDuration("AAVE-A", 4 hours);\n', '        DssExecLib.setIlkAuctionDuration("AAVE-A", 4 hours);\n', '        DssExecLib.setIlkBidDuration("UNIV2DAIETH-A", 4 hours);\n', '        DssExecLib.setIlkAuctionDuration("UNIV2DAIETH-A", 4 hours);\n', '        DssExecLib.setIlkBidDuration("UNIV2WBTCETH-A", 4 hours);\n', '        DssExecLib.setIlkAuctionDuration("UNIV2WBTCETH-A", 4 hours);\n', '        DssExecLib.setIlkBidDuration("UNIV2USDCETH-A", 4 hours);\n', '        DssExecLib.setIlkAuctionDuration("UNIV2USDCETH-A", 4 hours);\n', '        DssExecLib.setIlkBidDuration("UNIV2ETHUSDT-A", 4 hours);\n', '        DssExecLib.setIlkAuctionDuration("UNIV2ETHUSDT-A", 4 hours);\n', '        DssExecLib.setIlkBidDuration("UNIV2LINKETH-A", 4 hours);\n', '        DssExecLib.setIlkAuctionDuration("UNIV2LINKETH-A", 4 hours);\n', '        DssExecLib.setIlkBidDuration("UNIV2UNIETH-A", 4 hours);\n', '        DssExecLib.setIlkAuctionDuration("UNIV2UNIETH-A", 4 hours);\n', '        DssExecLib.setIlkBidDuration("UNIV2WBTCDAI-A", 4 hours);\n', '        DssExecLib.setIlkAuctionDuration("UNIV2WBTCDAI-A", 4 hours);\n', '        DssExecLib.setIlkBidDuration("UNIV2AAVEETH-A", 4 hours);\n', '        DssExecLib.setIlkAuctionDuration("UNIV2AAVEETH-A", 4 hours);\n', '        DssExecLib.setIlkBidDuration("UNIV2DAIUSDT-A", 4 hours);\n', '        DssExecLib.setIlkAuctionDuration("UNIV2DAIUSDT-A", 4 hours);\n', '\n', '        // Increase the box parameter from 15M to 20M\n', '        DssExecLib.setMaxTotalDAILiquidationAmount(20 * MILLION);\n', '\n', '        // Increase the minimum bid increment (beg) from 3% to 5% for the following collaterals\n', '        DssExecLib.setIlkMinAuctionBidIncrease("ETH-B", 500);\n', '        DssExecLib.setIlkMinAuctionBidIncrease("UNIV2USDCETH-A", 500);\n', '        DssExecLib.setIlkMinAuctionBidIncrease("UNIV2WBTCETH-A", 500);\n', '        DssExecLib.setIlkMinAuctionBidIncrease("UNIV2DAIETH-A", 500);\n', '        DssExecLib.setIlkMinAuctionBidIncrease("UNIV2UNIETH-A", 500);\n', '        DssExecLib.setIlkMinAuctionBidIncrease("UNIV2ETHUSDT-A", 500);\n', '        DssExecLib.setIlkMinAuctionBidIncrease("UNIV2LINKETH-A", 500);\n', '        DssExecLib.setIlkMinAuctionBidIncrease("UNIV2WBTCDAI-A", 500);\n', '        DssExecLib.setIlkMinAuctionBidIncrease("UNIV2AAVEETH-A", 500);\n', '        DssExecLib.setIlkMinAuctionBidIncrease("UNIV2DAIUSDT-A", 500);\n', '\n', '        // RWA001-A collateral deploy\n', '        bytes32 ilk = "RWA001-A";\n', '\n', '        address vat = DssExecLib.vat();\n', '\n', '        // Sanity checks\n', '        require(GemJoinAbstract(MCD_JOIN_RWA001_A).vat() == vat, "join-vat-not-match");\n', '        require(GemJoinAbstract(MCD_JOIN_RWA001_A).ilk() == ilk, "join-ilk-not-match");\n', '        require(GemJoinAbstract(MCD_JOIN_RWA001_A).gem() == RWA001_GEM, "join-gem-not-match");\n', '        require(GemJoinAbstract(MCD_JOIN_RWA001_A).dec() == DSTokenAbstract(RWA001_GEM).decimals(), "join-dec-not-match");\n', '\n', '        // init the RwaLiquidationOracle\n', '        // Oracle initial price: 1060\n', '        // doc: "https://ipfs.io/ipfs/QmdmAUTU3sd9VkdfTZNQM6krc9jsKgF2pz7W1qvvfJo1xk"\n', '        //   MIP13c3-SP4 Declaration of Intent & Commercial Points -\n', '        //   Off-Chain Asset Backed Lender to onboard Real World Assets\n', '        //   as Collateral for a DAI loan\n', '        // tau: 30 days\n', '        RwaLiquidationLike(MIP21_LIQUIDATION_ORACLE).init(\n', '            ilk, 1060 * WAD, "QmdmAUTU3sd9VkdfTZNQM6krc9jsKgF2pz7W1qvvfJo1xk", 30 days\n', '        );\n', '        (,address pip,,) = RwaLiquidationLike(MIP21_LIQUIDATION_ORACLE).ilks(ilk);\n', '\n', '        // Set price feed for RWA001\n', '        DssExecLib.setContract(DssExecLib.spotter(), ilk, "pip", pip);\n', '\n', '        // Init RWA-001 in Vat\n', '        Initializable(vat).init(ilk);\n', '        // Init RWA-001 in Jug\n', '        Initializable(DssExecLib.jug()).init(ilk);\n', '\n', '        // Allow RWA-001 Join to modify Vat registry\n', '        DssExecLib.authorize(vat, MCD_JOIN_RWA001_A);\n', '\n', '        // Allow RwaLiquidationOracle to modify Vat registry\n', '        DssExecLib.authorize(vat, MIP21_LIQUIDATION_ORACLE);\n', '\n', '        // Increase the global debt ceiling by the ilk ceiling\n', '        DssExecLib.increaseGlobalDebtCeiling(1_000);\n', '        // Set the ilk debt ceiling\n', '        DssExecLib.setIlkDebtCeiling(ilk, 1_000);\n', '\n', '        // No dust\n', '        // DssExecLib.setIlkMinVaultAmount(ilk, 0);\n', '\n', '        // 3% stability fee\n', '        DssExecLib.setIlkStabilityFee(ilk, THREE_PCT_RATE, false);\n', '\n', '        // collateralization ratio 100%\n', '        DssExecLib.setIlkLiquidationRatio(ilk, 10_000);\n', '\n', '        // poke the spotter to pull in a price\n', '        DssExecLib.updateCollateralPrice(ilk);\n', '\n', '        // give the urn permissions on the join adapter\n', '        DssExecLib.authorize(MCD_JOIN_RWA001_A, RWA001_A_URN);\n', '\n', '        // set up the urn\n', '        Hopeable(RWA001_A_URN).hope(RWA001_OPERATOR);\n', '\n', '        // set up output conduit\n', '        Hopeable(RWA001_A_OUTPUT_CONDUIT).hope(RWA001_OPERATOR);\n', '\n', '        // Authorize the SC Domain team deployer address on the output conduit during introductory phase.\n', '        //  This allows the SC team to assist in the testing of a complete circuit.\n', '        //  Once a broker dealer arrangement is established the deployer address should be `deny`ed on the conduit.\n', '        Kissable(RWA001_A_OUTPUT_CONDUIT).kiss(SC_DOMAIN_DEPLOYER_07);\n', '\n', '        // add RWA-001 contract to the changelog\n', '        DssExecLib.setChangelogAddress("RWA001", RWA001_GEM);\n', '        DssExecLib.setChangelogAddress("PIP_RWA001", pip);\n', '        DssExecLib.setChangelogAddress("MCD_JOIN_RWA001_A", MCD_JOIN_RWA001_A);\n', '        DssExecLib.setChangelogAddress("MIP21_LIQUIDATION_ORACLE", MIP21_LIQUIDATION_ORACLE);\n', '        DssExecLib.setChangelogAddress("RWA001_A_URN", RWA001_A_URN);\n', '        DssExecLib.setChangelogAddress("RWA001_A_INPUT_CONDUIT", RWA001_A_INPUT_CONDUIT);\n', '        DssExecLib.setChangelogAddress("RWA001_A_OUTPUT_CONDUIT", RWA001_A_OUTPUT_CONDUIT);\n', '\n', '        // bump changelog version\n', '        DssExecLib.setChangelogVersion("1.2.9");\n', '    }\n', '}\n', '\n', 'contract DssSpell is DssExec {\n', '    DssSpellAction internal action_ = new DssSpellAction();\n', '    constructor() DssExec(action_.description(), block.timestamp + 30 days, address(action_)) public {}\n', '}']