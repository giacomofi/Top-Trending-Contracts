['// Copyright (C) 2020 Maker Ecosystem Growth Holdings, INC.\n', '//\n', '// This program is free software: you can redistribute it and/or modify\n', '// it under the terms of the GNU Affero General Public License as published by\n', '// the Free Software Foundation, either version 3 of the License, or\n', '// (at your option) any later version.\n', '//\n', '// This program is distributed in the hope that it will be useful,\n', '// but WITHOUT ANY WARRANTY; without even the implied warranty of\n', '// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the\n', '// GNU Affero General Public License for more details.\n', '//\n', '// You should have received a copy of the GNU Affero General Public License\n', '// along with this program.  If not, see <https://www.gnu.org/licenses/>.\n', '\n', 'pragma solidity 0.5.12;\n', '\n', '// https://github.com/dapphub/ds-pause\n', 'interface DSPauseAbstract {\n', '    function delay() external view returns (uint256);\n', '    function plot(address, bytes32, bytes calldata, uint256) external;\n', '    function exec(address, bytes32, bytes calldata, uint256) external returns (bytes memory);\n', '}\n', '\n', '// https://github.com/makerdao/dss/blob/master/src/cat.sol\n', 'interface CatAbstract {\n', '    function wards(address) external view returns (uint256);\n', '    function rely(address) external;\n', '    function deny(address) external;\n', '    function box() external view returns (uint256);\n', '    function litter() external view returns (uint256);\n', '    function ilks(bytes32) external view returns (address, uint256, uint256);\n', '    function live() external view returns (uint256);\n', '    function vat() external view returns (address);\n', '    function vow() external view returns (address);\n', '    function file(bytes32, address) external;\n', '    function file(bytes32, uint256) external;\n', '    function file(bytes32, bytes32, uint256) external;\n', '    function file(bytes32, bytes32, address) external;\n', '    function bite(bytes32, address) external returns (uint256);\n', '    function claw(uint256) external;\n', '    function cage() external;\n', '}\n', '\n', '// https://github.com/makerdao/dss/blob/master/src/end.sol\n', 'interface EndAbstract {\n', '    function file(bytes32, address) external;\n', '    function file(bytes32, uint256) external;\n', '}\n', '\n', '// https://github.com/makerdao/dss/blob/master/src/flip.sol\n', 'interface FlipAbstract {\n', '    function rely(address usr) external;\n', '    function deny(address usr) external;\n', '    function vat() external view returns (address);\n', '    function cat() external view returns (address);\n', '    function ilk() external view returns (bytes32);\n', '    function beg() external view returns (uint256);\n', '    function ttl() external view returns (uint48);\n', '    function tau() external view returns (uint48);\n', '    function file(bytes32, uint256) external;\n', '}\n', '\n', '// https://github.com/makerdao/flipper-mom/blob/master/src/FlipperMom.sol\n', 'interface FlipperMomAbstract {\n', '    function setAuthority(address) external;\n', '    function cat() external returns (address);\n', '    function rely(address) external;\n', '    function deny(address) external;\n', '}\n', '\n', '// https://github.com/makerdao/osm\n', 'interface OsmAbstract {\n', '    function kiss(address) external;\n', '}\n', '\n', '// https://github.com/makerdao/dss/blob/master/src/vat.sol\n', 'interface VatAbstract {\n', '    function rely(address) external;\n', '    function deny(address) external;\n', '    function file(bytes32, uint256) external;\n', '    function file(bytes32, bytes32, uint256) external;\n', '}\n', '\n', '// https://github.com/makerdao/dss/blob/master/src/vow.sol\n', 'interface VowAbstract {\n', '    function rely(address usr) external;\n', '    function deny(address usr) external;\n', '}\n', '\n', 'contract SpellAction {\n', '\n', '    // MAINNET ADDRESSES\n', '    //\n', '    // The contracts in this list should correspond to MCD core contracts, verify\n', '    // against the current release list at:\n', '    //     https://changelog.makerdao.com/releases/mainnet/1.1.0/contracts.json\n', '\n', '    address constant MCD_VAT             = 0x35D1b3F3D7966A1DFe207aa4514C12a259A0492B;\n', '    address constant MCD_VOW             = 0xA950524441892A31ebddF91d3cEEFa04Bf454466;\n', '    address constant MCD_ADM             = 0x9eF05f7F6deB616fd37aC3c959a2dDD25A54E4F5;\n', '    address constant MCD_END             = 0xaB14d3CE3F733CACB76eC2AbE7d2fcb00c99F3d5;\n', '    address constant FLIPPER_MOM         = 0xc4bE7F74Ee3743bDEd8E0fA218ee5cf06397f472;\n', '    address constant MCD_CAT             = 0xa5679C04fc3d9d8b0AaB1F0ab83555b301cA70Ea;\n', '    address constant MCD_CAT_OLD         = 0x78F2c2AF65126834c51822F56Be0d7469D7A523E;\n', '\n', '    address constant MCD_FLIP_ETH_A      = 0xF32836B9E1f47a0515c6Ec431592D5EbC276407f;\n', '    address constant MCD_FLIP_ETH_A_OLD  = 0x0F398a2DaAa134621e4b687FCcfeE4CE47599Cc1;\n', '\n', '    address constant MCD_FLIP_BAT_A      = 0xF7C569B2B271354179AaCC9fF1e42390983110BA;\n', '    address constant MCD_FLIP_BAT_A_OLD  = 0x5EdF770FC81E7b8C2c89f71F30f211226a4d7495;\n', '\n', '    address constant MCD_FLIP_USDC_A     = 0xbe359e53038E41a1ffA47DAE39645756C80e557a;\n', '    address constant MCD_FLIP_USDC_A_OLD = 0x545521e0105C5698f75D6b3C3050CfCC62FB0C12;\n', '\n', '    address constant MCD_FLIP_USDC_B     = 0x77282aD36aADAfC16bCA42c865c674F108c4a616;\n', '    address constant MCD_FLIP_USDC_B_OLD = 0x6002d3B769D64A9909b0B26fC00361091786fe48;\n', '\n', '    address constant MCD_FLIP_WBTC_A     = 0x58CD24ac7322890382eE45A3E4F903a5B22Ee930;\n', '    address constant MCD_FLIP_WBTC_A_OLD = 0xF70590Fa4AaBe12d3613f5069D02B8702e058569;\n', '\n', '    address constant MCD_FLIP_ZRX_A      = 0xa4341cAf9F9F098ecb20fb2CeE2a0b8C78A18118;\n', '    address constant MCD_FLIP_ZRX_A_OLD  = 0x92645a34d07696395b6e5b8330b000D0436A9aAD;\n', '\n', '    address constant MCD_FLIP_KNC_A      = 0x57B01F1B3C59e2C0bdfF3EC9563B71EEc99a3f2f;\n', '    address constant MCD_FLIP_KNC_A_OLD  = 0xAD4a0B5F3c6Deb13ADE106Ba6E80Ca6566538eE6;\n', '\n', '    address constant MCD_FLIP_TUSD_A     = 0x9E4b213C4defbce7564F2Ac20B6E3bF40954C440;\n', '    address constant MCD_FLIP_TUSD_A_OLD = 0x04C42fAC3e29Fd27118609a5c36fD0b3Cb8090b3;\n', '\n', '    address constant MCD_FLIP_MANA_A     = 0x0a1D75B4f49BA80724a214599574080CD6B68357;\n', '    address constant MCD_FLIP_MANA_A_OLD = 0x4bf9D2EBC4c57B9B783C12D30076507660B58b3a;\n', '\n', '    address constant YEARN               = 0xCF63089A8aD2a9D8BD6Bb8022f3190EB7e1eD0f1;\n', '    address constant OSM_ETHUSD          = 0x81FE72B5A8d1A857d176C3E7d5Bd2679A9B85763;\n', '\n', '    // Decimals & precision\n', '    uint256 constant THOUSAND = 10 ** 3;\n', '    uint256 constant MILLION  = 10 ** 6;\n', '    uint256 constant WAD      = 10 ** 18;\n', '    uint256 constant RAY      = 10 ** 27;\n', '    uint256 constant RAD      = 10 ** 45;\n', '\n', '    function execute() external {\n', '\n', '        // ************************\n', '        // *** Liquidations 1.2 ***\n', '        // ************************\n', '\n', '        require(CatAbstract(MCD_CAT_OLD).vat() == MCD_VAT,          "non-matching-vat");\n', '        require(CatAbstract(MCD_CAT_OLD).vow() == MCD_VOW,          "non-matching-vow");\n', '\n', '        require(CatAbstract(MCD_CAT).vat() == MCD_VAT,              "non-matching-vat");\n', '        require(CatAbstract(MCD_CAT).live() == 1,                   "cat-not-live");\n', '\n', '        require(FlipperMomAbstract(FLIPPER_MOM).cat() == MCD_CAT,   "non-matching-cat");\n', '\n', '        /*** Update Cat ***/\n', '        CatAbstract(MCD_CAT).file("vow", MCD_VOW);\n', '        VatAbstract(MCD_VAT).rely(MCD_CAT);\n', '        VatAbstract(MCD_VAT).deny(MCD_CAT_OLD);\n', '        VowAbstract(MCD_VOW).rely(MCD_CAT);\n', '        VowAbstract(MCD_VOW).deny(MCD_CAT_OLD);\n', '        EndAbstract(MCD_END).file("cat", MCD_CAT);\n', '        CatAbstract(MCD_CAT).rely(MCD_END);\n', '\n', '        CatAbstract(MCD_CAT).file("box", 30 * MILLION * RAD);\n', '\n', '        /*** Set Auth in Flipper Mom ***/\n', '        FlipperMomAbstract(FLIPPER_MOM).setAuthority(MCD_ADM);\n', '\n', '        /*** ETH-A Flip ***/\n', '        _changeFlip(FlipAbstract(MCD_FLIP_ETH_A), FlipAbstract(MCD_FLIP_ETH_A_OLD));\n', '\n', '        /*** BAT-A Flip ***/\n', '        _changeFlip(FlipAbstract(MCD_FLIP_BAT_A), FlipAbstract(MCD_FLIP_BAT_A_OLD));\n', '\n', '        /*** USDC-A Flip ***/\n', '        _changeFlip(FlipAbstract(MCD_FLIP_USDC_A), FlipAbstract(MCD_FLIP_USDC_A_OLD));\n', '        FlipperMomAbstract(FLIPPER_MOM).deny(MCD_FLIP_USDC_A); // Auctions disabled\n', '\n', '        /*** USDC-B Flip ***/\n', '        _changeFlip(FlipAbstract(MCD_FLIP_USDC_B), FlipAbstract(MCD_FLIP_USDC_B_OLD));\n', '        FlipperMomAbstract(FLIPPER_MOM).deny(MCD_FLIP_USDC_B); // Auctions disabled\n', '\n', '        /*** WBTC-A Flip ***/\n', '        _changeFlip(FlipAbstract(MCD_FLIP_WBTC_A), FlipAbstract(MCD_FLIP_WBTC_A_OLD));\n', '\n', '        /*** TUSD-A Flip ***/\n', '        _changeFlip(FlipAbstract(MCD_FLIP_TUSD_A), FlipAbstract(MCD_FLIP_TUSD_A_OLD));\n', '        FlipperMomAbstract(FLIPPER_MOM).deny(MCD_FLIP_TUSD_A); // Auctions disabled\n', '\n', '        /*** ZRX-A Flip ***/\n', '        _changeFlip(FlipAbstract(MCD_FLIP_ZRX_A), FlipAbstract(MCD_FLIP_ZRX_A_OLD));\n', '\n', '        /*** KNC-A Flip ***/\n', '        _changeFlip(FlipAbstract(MCD_FLIP_KNC_A), FlipAbstract(MCD_FLIP_KNC_A_OLD));\n', '\n', '        /*** MANA-A Flip ***/\n', '        _changeFlip(FlipAbstract(MCD_FLIP_MANA_A), FlipAbstract(MCD_FLIP_MANA_A_OLD));\n', '\n', '        // *********************\n', '        // *** Other Changes ***\n', '        // *********************\n', '\n', '        /*** Risk Parameter Adjustments ***/\n', '\n', '        // set the global debt ceiling to 588,000,000\n', '        // 688 (current DC) - 100 (USDC-A decrease)\n', '        VatAbstract(MCD_VAT).file("Line", 588 * MILLION * RAD);\n', '\n', '        // Set the USDC-A debt ceiling\n', '        //\n', '        // Existing debt: 140 million\n', '        // New debt ceiling: 40 million\n', '        uint256 USDC_A_LINE = 40 * MILLION * RAD;\n', '        VatAbstract(MCD_VAT).file("USDC-A", "line", USDC_A_LINE);\n', '\n', '        /*** Whitelist yearn on ETHUSD Oracle ***/\n', '        OsmAbstract(OSM_ETHUSD).kiss(YEARN);\n', '    }\n', '\n', '    function _changeFlip(FlipAbstract newFlip, FlipAbstract oldFlip) internal {\n', '        bytes32 ilk = newFlip.ilk();\n', '        require(ilk == oldFlip.ilk(), "non-matching-ilk");\n', '        require(newFlip.vat() == oldFlip.vat(), "non-matching-vat");\n', '        require(newFlip.cat() == MCD_CAT, "non-matching-cat");\n', '        require(newFlip.vat() == MCD_VAT, "non-matching-vat");\n', '\n', '        CatAbstract(MCD_CAT).file(ilk, "flip", address(newFlip));\n', '        (, uint oldChop,) = CatAbstract(MCD_CAT_OLD).ilks(ilk);\n', '        CatAbstract(MCD_CAT).file(ilk, "chop", oldChop / 10 ** 9);\n', '\n', '        CatAbstract(MCD_CAT).file(ilk, "dunk", 50 * THOUSAND * RAD);\n', '        CatAbstract(MCD_CAT).rely(address(newFlip));\n', '\n', '        newFlip.rely(MCD_CAT);\n', '        newFlip.rely(MCD_END);\n', '        newFlip.rely(FLIPPER_MOM);\n', '        newFlip.file("beg", oldFlip.beg());\n', '        newFlip.file("ttl", oldFlip.ttl());\n', '        newFlip.file("tau", oldFlip.tau());\n', '    }\n', '}\n', '\n', 'contract DssSpell {\n', '    DSPauseAbstract public pause =\n', '        DSPauseAbstract(0xbE286431454714F511008713973d3B053A2d38f3);\n', '    address         public action;\n', '    bytes32         public tag;\n', '    uint256         public eta;\n', '    bytes           public sig;\n', '    uint256         public expiration;\n', '    bool            public done;\n', '\n', '    // Provides a descriptive tag for bot consumption\n', '    // This should be modified weekly to provide a summary of the actions\n', '    // Hash: seth keccak -- "$(wget https://raw.githubusercontent.com/makerdao/community/6304d5d461f6a0811699eb04fa48b95d68515d8f/governance/votes/Executive%20vote%20-%20August%2028%2C%202020.md -q -O - 2>/dev/null)"\n', '    string constant public description =\n', '        "2020-08-28 MakerDAO Executive Spell | Hash: 0x67885f84f0d31dc816fc327d9912bae6f207199d299543d95baff20cf6305963";\n', '\n', '    constructor() public {\n', '        sig = abi.encodeWithSignature("execute()");\n', '        action = address(new SpellAction());\n', '        bytes32 _tag;\n', '        address _action = action;\n', '        assembly { _tag := extcodehash(_action) }\n', '        tag = _tag;\n', '        expiration = now + 30 days;\n', '    }\n', '\n', '    modifier officeHours {\n', '        uint day = (now / 1 days + 3) % 7;\n', '        require(day < 5, "Can only be cast on a weekday");\n', '        uint hour = now / 1 hours % 24;\n', '        require(hour >= 14 && hour < 21, "Outside office hours");\n', '        _;\n', '    }\n', '\n', '    function schedule() public {\n', '        require(now <= expiration, "This contract has expired");\n', '        require(eta == 0, "This spell has already been scheduled");\n', '        eta = now + DSPauseAbstract(pause).delay();\n', '        pause.plot(action, tag, sig, eta);\n', '    }\n', '\n', '    function cast() public officeHours {\n', '        require(!done, "spell-already-cast");\n', '        done = true;\n', '        pause.exec(action, tag, sig, eta);\n', '    }\n', '}']