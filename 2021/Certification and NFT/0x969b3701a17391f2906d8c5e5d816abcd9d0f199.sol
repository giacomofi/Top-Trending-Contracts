['/**\n', ' *Submitted for verification at Etherscan.io on 2021-02-26\n', '*/\n', '\n', '// hevm: flattened sources of src/DssSpell.sol\n', 'pragma solidity =0.6.11 >=0.6.11 <0.7.0;\n', '\n', '////// lib/dss-exec-lib/src/CollateralOpts.sol\n', '/* pragma solidity ^0.6.11; */\n', '\n', 'struct CollateralOpts {\n', '    bytes32 ilk;\n', '    address gem;\n', '    address join;\n', '    address flip;\n', '    address pip;\n', '    bool    isLiquidatable;\n', '    bool    isOSM;\n', '    bool    whitelistOSM;\n', '    uint256 ilkDebtCeiling;\n', '    uint256 minVaultAmount;\n', '    uint256 maxLiquidationAmount;\n', '    uint256 liquidationPenalty;\n', '    uint256 ilkStabilityFee;\n', '    uint256 bidIncrease;\n', '    uint256 bidDuration;\n', '    uint256 auctionDuration;\n', '    uint256 liquidationRatio;\n', '}\n', '\n', '////// lib/dss-exec-lib/src/DssExecLib.sol\n', '//\n', '// DssExecLib.sol -- MakerDAO Executive Spellcrafting Library\n', '//\n', '// Copyright (C) 2020 Maker Ecosystem Growth Holdings, Inc.\n', '//\n', '// This program is free software: you can redistribute it and/or modify\n', '// it under the terms of the GNU Affero General Public License as published by\n', '// the Free Software Foundation, either version 3 of the License, or\n', '// (at your option) any later version.\n', '//\n', '// This program is distributed in the hope that it will be useful,\n', '// but WITHOUT ANY WARRANTY; without even the implied warranty of\n', '// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the\n', '// GNU Affero General Public License for more details.\n', '//\n', '// You should have received a copy of the GNU Affero General Public License\n', '// along with this program.  If not, see <https://www.gnu.org/licenses/>.\n', '/* pragma solidity ^0.6.11; */\n', '\n', 'interface Initializable {\n', '    function init(bytes32) external;\n', '}\n', '\n', 'interface Authorizable {\n', '    function rely(address) external;\n', '    function deny(address) external;\n', '}\n', '\n', 'interface Fileable_1 {\n', '    function file(bytes32, address) external;\n', '    function file(bytes32, uint256) external;\n', '    function file(bytes32, bytes32, uint256) external;\n', '    function file(bytes32, bytes32, address) external;\n', '}\n', '\n', 'interface Drippable {\n', '    function drip() external returns (uint256);\n', '    function drip(bytes32) external returns (uint256);\n', '}\n', '\n', 'interface Pricing {\n', '    function poke(bytes32) external;\n', '}\n', '\n', 'interface ERC20 {\n', '    function decimals() external returns (uint8);\n', '}\n', '\n', 'interface DssVat {\n', '    function hope(address) external;\n', '    function nope(address) external;\n', '    function ilks(bytes32) external returns (uint256 Art, uint256 rate, uint256 spot, uint256 line, uint256 dust);\n', '    function Line() external view returns (uint256);\n', '    function suck(address, address, uint) external;\n', '}\n', '\n', 'interface AuctionLike {\n', '    function vat() external returns (address);\n', '    function cat() external returns (address); // Only flip\n', '    function beg() external returns (uint256);\n', '    function pad() external returns (uint256); // Only flop\n', '    function ttl() external returns (uint256);\n', '    function tau() external returns (uint256);\n', '    function ilk() external returns (bytes32); // Only flip\n', '    function gem() external returns (bytes32); // Only flap/flop\n', '}\n', '\n', 'interface JoinLike {\n', '    function vat() external returns (address);\n', '    function ilk() external returns (bytes32);\n', '    function gem() external returns (address);\n', '    function dec() external returns (uint256);\n', '    function join(address, uint) external;\n', '    function exit(address, uint) external;\n', '}\n', '\n', '// Includes Median and OSM functions\n', 'interface OracleLike_2 {\n', '    function src() external view returns (address);\n', '    function lift(address[] calldata) external;\n', '    function drop(address[] calldata) external;\n', '    function setBar(uint256) external;\n', '    function kiss(address) external;\n', '    function diss(address) external;\n', '    function kiss(address[] calldata) external;\n', '    function diss(address[] calldata) external;\n', '}\n', '\n', 'interface MomLike {\n', '    function setOsm(bytes32, address) external;\n', '}\n', '\n', 'interface RegistryLike {\n', '    function add(address) external;\n', '    function info(bytes32) external view returns (\n', '        string memory, string memory, uint256, address, address, address, address\n', '    );\n', '    function ilkData(bytes32) external view returns (\n', '        uint256       pos,\n', '        address       gem,\n', '        address       pip,\n', '        address       join,\n', '        address       flip,\n', '        uint256       dec,\n', '        string memory name,\n', '        string memory symbol\n', '    );\n', '}\n', '\n', '// https://github.com/makerdao/dss-chain-log\n', 'interface ChainlogLike {\n', '    function setVersion(string calldata) external;\n', '    function setIPFS(string calldata) external;\n', '    function setSha256sum(string calldata) external;\n', '    function getAddress(bytes32) external view returns (address);\n', '    function setAddress(bytes32, address) external;\n', '    function removeAddress(bytes32) external;\n', '}\n', '\n', 'interface IAMLike {\n', '    function ilks(bytes32) external view returns (uint256,uint256,uint48,uint48,uint48);\n', '    function setIlk(bytes32,uint256,uint256,uint256) external;\n', '    function remIlk(bytes32) external;\n', '    function exec(bytes32) external returns (uint256);\n', '}\n', '\n', '\n', 'library DssExecLib {\n', '\n', '    // Function stubs - check the actual library address for implementations\n', '    function dai()        public view returns (address) {}\n', '    function mkr()        public view returns (address) {}\n', '    function vat()        public view returns (address) {}\n', '    function cat()        public view returns (address) {}\n', '    function jug()        public view returns (address) {}\n', '    function pot()        public view returns (address) {}\n', '    function vow()        public view returns (address) {}\n', '    function end()        public view returns (address) {}\n', '    function reg()        public view returns (address) {}\n', '    function spotter()    public view returns (address) {}\n', '    function flap()       public view returns (address) {}\n', '    function flop()       public view returns (address) {}\n', '    function osmMom()     public view returns (address) {}\n', '    function govGuard()   public view returns (address) {}\n', '    function flipperMom() public view returns (address) {}\n', '    function pauseProxy() public view returns (address) {}\n', '    function autoLine()   public view returns (address) {}\n', '    function daiJoin()    public view returns (address) {}\n', '    function flip(bytes32 ilk) public view returns (address _flip) {\n', '    }\n', '    function getChangelogAddress(bytes32 key) public view returns (address) {\n', '    }\n', '    function setChangelogAddress(bytes32 _key, address _val) public {\n', '    }\n', '    function setChangelogVersion(string memory _version) public {\n', '    }\n', '    function setChangelogIPFS(string memory _ipfsHash) public {\n', '    }\n', '    function setChangelogSHA256(string memory _SHA256Sum) public {\n', '    }\n', '    function authorize(address _base, address _ward) public {\n', '    }\n', '    function deauthorize(address _base, address _ward) public {\n', '    }\n', '    function delegateVat(address _usr) public {\n', '    }\n', '    function undelegateVat(address _usr) public {\n', '    }\n', '    function accumulateDSR() public {\n', '    }\n', '    function accumulateCollateralStabilityFees(bytes32 _ilk) public {\n', '    }\n', '    function updateCollateralPrice(bytes32 _ilk) public {\n', '    }\n', '    function setContract(address _base, bytes32 _what, address _addr) public {\n', '    }\n', '    function setContract(address _base, bytes32 _ilk, bytes32 _what, address _addr) public {\n', '    }\n', '    function setGlobalDebtCeiling(uint256 _amount) public {\n', '    }\n', '    function increaseGlobalDebtCeiling(uint256 _amount) public {\n', '    }\n', '    function decreaseGlobalDebtCeiling(uint256 _amount) public {\n', '    }\n', '    function setDSR(uint256 _rate) public {\n', '    }\n', '    function setSurplusAuctionAmount(uint256 _amount) public {\n', '    }\n', '    function setSurplusBuffer(uint256 _amount) public {\n', '    }\n', '    function setMinSurplusAuctionBidIncrease(uint256 _pct_bps) public {\n', '    }\n', '    function setSurplusAuctionBidDuration(uint256 _duration) public {\n', '    }\n', '    function setSurplusAuctionDuration(uint256 _duration) public {\n', '    }\n', '    function setDebtAuctionDelay(uint256 _duration) public {\n', '    }\n', '    function setDebtAuctionDAIAmount(uint256 _amount) public {\n', '    }\n', '    function setDebtAuctionMKRAmount(uint256 _amount) public {\n', '    }\n', '    function setMinDebtAuctionBidIncrease(uint256 _pct_bps) public {\n', '    }\n', '    function setDebtAuctionBidDuration(uint256 _duration) public {\n', '    }\n', '    function setDebtAuctionDuration(uint256 _duration) public {\n', '    }\n', '    function setDebtAuctionMKRIncreaseRate(uint256 _pct_bps) public {\n', '    }\n', '    function setMaxTotalDAILiquidationAmount(uint256 _amount) public {\n', '    }\n', '    function setEmergencyShutdownProcessingTime(uint256 _duration) public {\n', '    }\n', '    function setGlobalStabilityFee(uint256 _rate) public {\n', '    }\n', '    function setDAIReferenceValue(uint256 _value) public {\n', '    }\n', '    function setIlkDebtCeiling(bytes32 _ilk, uint256 _amount) public {\n', '    }\n', '    function increaseIlkDebtCeiling(bytes32 _ilk, uint256 _amount, bool _global) public {\n', '    }\n', '    function decreaseIlkDebtCeiling(bytes32 _ilk, uint256 _amount, bool _global) public {\n', '    }\n', '    function setIlkAutoLineParameters(bytes32 _ilk, uint256 _amount, uint256 _gap, uint256 _ttl) public {\n', '    }\n', '    function setIlkAutoLineDebtCeiling(bytes32 _ilk, uint256 _amount) public {\n', '    }\n', '    function removeIlkFromAutoLine(bytes32 _ilk) public {\n', '    }\n', '    function setIlkMinVaultAmount(bytes32 _ilk, uint256 _amount) public {\n', '    }\n', '    function setIlkLiquidationPenalty(bytes32 _ilk, uint256 _pct_bps) public {\n', '    }\n', '    function setIlkMaxLiquidationAmount(bytes32 _ilk, uint256 _amount) public {\n', '    }\n', '    function setIlkLiquidationRatio(bytes32 _ilk, uint256 _pct_bps) public {\n', '    }\n', '    function setIlkMinAuctionBidIncrease(bytes32 _ilk, uint256 _pct_bps) public {\n', '    }\n', '    function setIlkBidDuration(bytes32 _ilk, uint256 _duration) public {\n', '    }\n', '    function setIlkAuctionDuration(bytes32 _ilk, uint256 _duration) public {\n', '    }\n', '    function setIlkStabilityFee(bytes32 _ilk, uint256 _rate, bool _doDrip) public {\n', '    }\n', '    function addWritersToMedianWhitelist(address _median, address[] memory _feeds) public {\n', '        OracleLike_2(_median).lift(_feeds);\n', '    }\n', '    function removeWritersFromMedianWhitelist(address _median, address[] memory _feeds) public {\n', '        OracleLike_2(_median).drop(_feeds);\n', '    }\n', '    function addReadersToMedianWhitelist(address _median, address[] memory _readers) public {\n', '        OracleLike_2(_median).kiss(_readers);\n', '    }\n', '    function addReaderToMedianWhitelist(address _median, address _reader) public {\n', '        OracleLike_2(_median).kiss(_reader);\n', '    }\n', '    function removeReadersFromMedianWhitelist(address _median, address[] memory _readers) public {\n', '    }\n', '    function removeReaderFromMedianWhitelist(address _median, address _reader) public {\n', '    }\n', '    function setMedianWritersQuorum(address _median, uint256 _minQuorum) public {\n', '    }\n', '    function addReaderToOSMWhitelist(address _osm, address _reader) public {\n', '    }\n', '    function removeReaderFromOSMWhitelist(address _osm, address _reader) public {\n', '    }\n', '    function allowOSMFreeze(address _osm, bytes32 _ilk) public {\n', '    }\n', '    function addCollateralBase(\n', '        bytes32 _ilk,\n', '        address _gem,\n', '        address _join,\n', '        address _flip,\n', '        address _pip\n', '    ) public {\n', '    }\n', '    function sendPaymentFromSurplusBuffer(address _target, uint256 _amount) public {\n', '    }\n', '}\n', '\n', '////// lib/dss-exec-lib/src/DssAction.sol\n', '//\n', '// DssAction.sol -- DSS Executive Spell Actions\n', '//\n', '// Copyright (C) 2020 Maker Ecosystem Growth Holdings, Inc.\n', '//\n', '// This program is free software: you can redistribute it and/or modify\n', '// it under the terms of the GNU Affero General Public License as published by\n', '// the Free Software Foundation, either version 3 of the License, or\n', '// (at your option) any later version.\n', '//\n', '// This program is distributed in the hope that it will be useful,\n', '// but WITHOUT ANY WARRANTY; without even the implied warranty of\n', '// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the\n', '// GNU Affero General Public License for more details.\n', '//\n', '// You should have received a copy of the GNU Affero General Public License\n', '// along with this program.  If not, see <https://www.gnu.org/licenses/>.\n', '\n', '/* pragma solidity ^0.6.11; */\n', '\n', '/* import "./CollateralOpts.sol"; */\n', '/* import { DssExecLib } from "./DssExecLib.sol"; */\n', '\n', 'interface OracleLike_1 {\n', '    function src() external view returns (address);\n', '}\n', '\n', 'abstract contract DssAction {\n', '\n', '    using DssExecLib for *;\n', '\n', '    // Office Hours defaults to true by default.\n', '    //   To disable office hours, override this function and\n', '    //    return false in the inherited action.\n', '    function officeHours() public virtual returns (bool) {\n', '        return true;\n', '    }\n', '\n', '    // DssExec calls execute. We limit this function subject to officeHours modifier.\n', '    function execute() external limited {\n', '        actions();\n', '    }\n', '\n', '    // DssAction developer must override `actions()` and place all actions to be called inside.\n', '    //   The DssExec function will call this subject to the officeHours limiter\n', '    //   By keeping this function public we allow simulations of `execute()` on the actions outside of the cast time.\n', '    function actions() public virtual;\n', '\n', '    // Modifier required to\n', '    modifier limited {\n', '        if (officeHours()) {\n', '            uint day = (block.timestamp / 1 days + 3) % 7;\n', '            require(day < 5, "Can only be cast on a weekday");\n', '            uint hour = block.timestamp / 1 hours % 24;\n', '            require(hour >= 14 && hour < 21, "Outside office hours");\n', '        }\n', '        _;\n', '    }\n', '\n', '    /*****************************/\n', '    /*** Collateral Onboarding ***/\n', '    /*****************************/\n', '\n', '    // Complete collateral onboarding logic.\n', '    function addNewCollateral(CollateralOpts memory co) internal {\n', '        // Add the collateral to the system.\n', '        DssExecLib.addCollateralBase(co.ilk, co.gem, co.join, co.flip, co.pip);\n', '\n', '        // Allow FlipperMom to access to the ilk Flipper\n', '        address _flipperMom = DssExecLib.flipperMom();\n', '        DssExecLib.authorize(co.flip, _flipperMom);\n', '        // Disallow Cat to kick auctions in ilk Flipper\n', '        if(!co.isLiquidatable) { DssExecLib.deauthorize(_flipperMom, co.flip); }\n', '\n', '        if(co.isOSM) { // If pip == OSM\n', '            // Allow OsmMom to access to the TOKEN OSM\n', '            DssExecLib.authorize(co.pip, DssExecLib.osmMom());\n', '            if (co.whitelistOSM) { // If median is src in OSM\n', '                // Whitelist OSM to read the Median data (only necessary if it is the first time the token is being added to an ilk)\n', '                DssExecLib.addReaderToMedianWhitelist(address(OracleLike_1(co.pip).src()), co.pip);\n', '            }\n', '            // Whitelist Spotter to read the OSM data (only necessary if it is the first time the token is being added to an ilk)\n', '            DssExecLib.addReaderToOSMWhitelist(co.pip, DssExecLib.spotter());\n', '            // Whitelist End to read the OSM data (only necessary if it is the first time the token is being added to an ilk)\n', '            DssExecLib.addReaderToOSMWhitelist(co.pip, DssExecLib.end());\n', '            // Set TOKEN OSM in the OsmMom for new ilk\n', '            DssExecLib.allowOSMFreeze(co.pip, co.ilk);\n', '        }\n', '        // Increase the global debt ceiling by the ilk ceiling\n', '        DssExecLib.increaseGlobalDebtCeiling(co.ilkDebtCeiling);\n', '        // Set the ilk debt ceiling\n', '        DssExecLib.setIlkDebtCeiling(co.ilk, co.ilkDebtCeiling);\n', '        // Set the ilk dust\n', '        DssExecLib.setIlkMinVaultAmount(co.ilk, co.minVaultAmount);\n', '        // Set the dunk size\n', '        DssExecLib.setIlkMaxLiquidationAmount(co.ilk, co.maxLiquidationAmount);\n', '        // Set the ilk liquidation penalty\n', '        DssExecLib.setIlkLiquidationPenalty(co.ilk, co.liquidationPenalty);\n', '\n', '        // Set the ilk stability fee\n', '        DssExecLib.setIlkStabilityFee(co.ilk, co.ilkStabilityFee, true);\n', '\n', '        // Set the ilk percentage between bids\n', '        DssExecLib.setIlkMinAuctionBidIncrease(co.ilk, co.bidIncrease);\n', '        // Set the ilk time max time between bids\n', '        DssExecLib.setIlkBidDuration(co.ilk, co.bidDuration);\n', '        // Set the ilk max auction duration\n', '        DssExecLib.setIlkAuctionDuration(co.ilk, co.auctionDuration);\n', '        // Set the ilk min collateralization ratio\n', '        DssExecLib.setIlkLiquidationRatio(co.ilk, co.liquidationRatio);\n', '\n', '        // Update ilk spot value in Vat\n', '        DssExecLib.updateCollateralPrice(co.ilk);\n', '    }\n', '}\n', '\n', '////// lib/dss-exec-lib/src/DssExec.sol\n', '//\n', '// DssExec.sol -- MakerDAO Executive Spell Template\n', '//\n', '// Copyright (C) 2020 Maker Ecosystem Growth Holdings, Inc.\n', '//\n', '// This program is free software: you can redistribute it and/or modify\n', '// it under the terms of the GNU Affero General Public License as published by\n', '// the Free Software Foundation, either version 3 of the License, or\n', '// (at your option) any later version.\n', '//\n', '// This program is distributed in the hope that it will be useful,\n', '// but WITHOUT ANY WARRANTY; without even the implied warranty of\n', '// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the\n', '// GNU Affero General Public License for more details.\n', '//\n', '// You should have received a copy of the GNU Affero General Public License\n', '// along with this program.  If not, see <https://www.gnu.org/licenses/>.\n', '\n', '/* pragma solidity ^0.6.11; */\n', '\n', 'interface PauseAbstract {\n', '    function delay() external view returns (uint256);\n', '    function plot(address, bytes32, bytes calldata, uint256) external;\n', '    function exec(address, bytes32, bytes calldata, uint256) external returns (bytes memory);\n', '}\n', '\n', 'interface Changelog {\n', '    function getAddress(bytes32) external view returns (address);\n', '}\n', '\n', 'interface SpellAction {\n', '    function officeHours() external view returns (bool);\n', '}\n', '\n', 'contract DssExec {\n', '\n', '    Changelog      constant public log   = Changelog(0xdA0Ab1e0017DEbCd72Be8599041a2aa3bA7e740F);\n', '    uint256                 public eta;\n', '    bytes                   public sig;\n', '    bool                    public done;\n', '    bytes32       immutable public tag;\n', '    address       immutable public action;\n', '    uint256       immutable public expiration;\n', '    PauseAbstract immutable public pause;\n', '\n', '    // Provides a descriptive tag for bot consumption\n', '    // This should be modified weekly to provide a summary of the actions\n', '    // Hash: seth keccak -- "$(wget https://<executive-vote-canonical-post> -q -O - 2>/dev/null)"\n', '    string                  public description;\n', '\n', '    function officeHours() external view returns (bool) {\n', '        return SpellAction(action).officeHours();\n', '    }\n', '\n', '    function nextCastTime() external view returns (uint256 castTime) {\n', '        require(eta != 0, "DssExec/spell-not-scheduled");\n', '        castTime = block.timestamp > eta ? block.timestamp : eta; // Any day at XX:YY\n', '\n', '        if (SpellAction(action).officeHours()) {\n', '            uint256 day    = (castTime / 1 days + 3) % 7;\n', '            uint256 hour   = castTime / 1 hours % 24;\n', '            uint256 minute = castTime / 1 minutes % 60;\n', '            uint256 second = castTime % 60;\n', '\n', '            if (day >= 5) {\n', '                castTime += (6 - day) * 1 days;                 // Go to Sunday XX:YY\n', '                castTime += (24 - hour + 14) * 1 hours;         // Go to 14:YY UTC Monday\n', '                castTime -= minute * 1 minutes + second;        // Go to 14:00 UTC\n', '            } else {\n', '                if (hour >= 21) {\n', '                    if (day == 4) castTime += 2 days;           // If Friday, fast forward to Sunday XX:YY\n', '                    castTime += (24 - hour + 14) * 1 hours;     // Go to 14:YY UTC next day\n', '                    castTime -= minute * 1 minutes + second;    // Go to 14:00 UTC\n', '                } else if (hour < 14) {\n', '                    castTime += (14 - hour) * 1 hours;          // Go to 14:YY UTC same day\n', '                    castTime -= minute * 1 minutes + second;    // Go to 14:00 UTC\n', '                }\n', '            }\n', '        }\n', '    }\n', '\n', '    // @param _description  A string description of the spell\n', '    // @param _expiration   The timestamp this spell will expire. (Ex. now + 30 days)\n', '    // @param _spellAction  The address of the spell action\n', '    constructor(string memory _description, uint256 _expiration, address _spellAction) public {\n', '        pause       = PauseAbstract(log.getAddress("MCD_PAUSE"));\n', '        description = _description;\n', '        expiration  = _expiration;\n', '        action      = _spellAction;\n', '\n', '        sig = abi.encodeWithSignature("execute()");\n', '        bytes32 _tag;                    // Required for assembly access\n', '        address _action = _spellAction;  // Required for assembly access\n', '        assembly { _tag := extcodehash(_action) }\n', '        tag = _tag;\n', '    }\n', '\n', '    function schedule() public {\n', '        require(now <= expiration, "This contract has expired");\n', '        require(eta == 0, "This spell has already been scheduled");\n', '        eta = now + PauseAbstract(pause).delay();\n', '        pause.plot(action, tag, sig, eta);\n', '    }\n', '\n', '    function cast() public {\n', '        require(!done, "spell-already-cast");\n', '        done = true;\n', '        pause.exec(action, tag, sig, eta);\n', '    }\n', '}\n', '\n', '////// src/DssSpell.sol\n', '// SPDX-License-Identifier: GPL-3.0-or-later\n', '// Copyright (C) 2021 Maker Ecosystem Growth Holdings, INC.\n', '//\n', '// This program is free software: you can redistribute it and/or modify\n', '// it under the terms of the GNU Affero General Public License as published by\n', '// the Free Software Foundation, either version 3 of the License, or\n', '// (at your option) any later version.\n', '//\n', '// This program is distributed in the hope that it will be useful,\n', '// but WITHOUT ANY WARRANTY; without even the implied warranty of\n', '// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the\n', '// GNU Affero General Public License for more details.\n', '//\n', '// You should have received a copy of the GNU Affero General Public License\n', '// along with this program.  If not, see <https://www.gnu.org/licenses/>.\n', '/* pragma solidity 0.6.11; */\n', '\n', '/* import "dss-exec-lib/DssExec.sol"; */\n', '/* import "dss-exec-lib/DssAction.sol"; */\n', '\n', 'interface ChainlogAbstract_2 {\n', '    function removeAddress(bytes32) external;\n', '}\n', '\n', 'interface LPOracle {\n', '    function orb0() external view returns (address);\n', '    function orb1() external view returns (address);\n', '}\n', '\n', 'interface Fileable_2 {\n', '    function file(bytes32,uint256) external;\n', '}\n', '\n', 'contract DssSpellAction is DssAction {\n', '\n', '    // Provides a descriptive tag for bot consumption\n', '    // This should be modified weekly to provide a summary of the actions\n', '    // Hash: seth keccak -- "$(wget https://raw.githubusercontent.com/makerdao/community/46cbe46a16b7836d6b219201e3a07d40b01a7db4/governance/votes/Community%20Executive%20vote%20-%20February%2026%2C%202021.md -q -O - 2>/dev/null)"\n', '    string public constant description =\n', '        "2021-02-26 MakerDAO Executive Spell | Hash: 0x4c91fafa587264790d3ad6498caf9c0070a810237c46bb7f3b2556e043ba7b23";\n', '\n', '\n', '    // Many of the settings that change weekly rely on the rate accumulator\n', '    // described at https://docs.makerdao.com/smart-contract-modules/rates-module\n', '    // To check this yourself, use the following rate calculation (example 8%):\n', '    //\n', "    // $ bc -l <<< 'scale=27; e( l(1.08)/(60 * 60 * 24 * 365) )'\n", '    //\n', '    // A table of rates can be found at\n', '    //    https://ipfs.io/ipfs/QmefQMseb3AiTapiAKKexdKHig8wroKuZbmLtPLv4u2YwW\n', '    //\n', '    uint256 constant FOUR_PCT           = 1000000001243680656318820312;\n', '    uint256 constant FIVE_PT_FIVE_PCT   = 1000000001697766583380253701;\n', '    uint256 constant NINE_PCT           = 1000000002732676825177582095;\n', '\n', '    uint256 constant WAD        = 10**18;\n', '    uint256 constant RAD        = 10**45;\n', '    uint256 constant MILLION    = 10**6;\n', '\n', '    address constant UNIV2DAIUSDT_GEM   = 0xB20bd5D04BE54f870D5C0d3cA85d82b34B836405;\n', '    address constant UNIV2DAIUSDT_JOIN  = 0xAf034D882169328CAf43b823a4083dABC7EEE0F4;\n', '    address constant UNIV2DAIUSDT_FLIP  = 0xD32f8B8aDbE331eC0CfADa9cfDbc537619622cFe;\n', '    address constant UNIV2DAIUSDT_PIP   = 0x69562A7812830E6854Ffc50b992c2AA861D5C2d3;\n', '\n', '    function actions() public override {\n', '        // Rates Proposal - February 22, 2021\n', '        DssExecLib.setIlkStabilityFee("ETH-A", FIVE_PT_FIVE_PCT, true);\n', '        DssExecLib.setIlkStabilityFee("ETH-B", NINE_PCT, true);\n', '\n', '        // Onboard UNIV2DAIUSDT-A\n', '        DssExecLib.addReaderToMedianWhitelist(\n', '            LPOracle(UNIV2DAIUSDT_PIP).orb1(),\n', '            UNIV2DAIUSDT_PIP\n', '        );\n', '        CollateralOpts memory UNIV2DAIUSDT_A = CollateralOpts({\n', '            ilk: "UNIV2DAIUSDT-A",\n', '            gem: UNIV2DAIUSDT_GEM,\n', '            join: UNIV2DAIUSDT_JOIN,\n', '            flip: UNIV2DAIUSDT_FLIP,\n', '            pip: UNIV2DAIUSDT_PIP,\n', '            isLiquidatable: true,\n', '            isOSM: true,\n', '            whitelistOSM: false,\n', '            ilkDebtCeiling: 3 * MILLION,\n', '            minVaultAmount: 2000,\n', '            maxLiquidationAmount: 50000,\n', '            liquidationPenalty: 1300,\n', '            ilkStabilityFee: FOUR_PCT,\n', '            bidIncrease: 300,\n', '            bidDuration: 6 hours,\n', '            auctionDuration: 6 hours,\n', '            liquidationRatio: 12500\n', '        });\n', '        addNewCollateral(UNIV2DAIUSDT_A);\n', '        DssExecLib.setChangelogAddress("UNIV2DAIUSDT",             UNIV2DAIUSDT_GEM);\n', '        DssExecLib.setChangelogAddress("MCD_JOIN_UNIV2DAIUSDT_A",  UNIV2DAIUSDT_JOIN);\n', '        DssExecLib.setChangelogAddress("MCD_FLIP_UNIV2DAIUSDT_A",  UNIV2DAIUSDT_FLIP);\n', '        DssExecLib.setChangelogAddress("PIP_UNIV2DAIUSDT",         UNIV2DAIUSDT_PIP);\n', '\n', '        // Lower PSM-USDC-A Toll Out\n', '        Fileable_2(DssExecLib.getChangelogAddress("MCD_PSM_USDC_A")).file("tout", 4 * WAD / 10000);\n', '\n', '        // bump Changelog version\n', '        DssExecLib.setChangelogVersion("1.2.8");\n', '    }\n', '}\n', '\n', 'contract DssSpell is DssExec {\n', '    DssSpellAction internal action_ = new DssSpellAction();\n', '    constructor() DssExec(action_.description(), block.timestamp + 30 days, address(action_)) public {}\n', '}']