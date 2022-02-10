['// Copyright (C) 2020 Maker Ecosystem Growth Holdings, INC.\n', '//\n', '// This program is free software: you can redistribute it and/or modify\n', '// it under the terms of the GNU Affero General Public License as published by\n', '// the Free Software Foundation, either version 3 of the License, or\n', '// (at your option) any later version.\n', '//\n', '// This program is distributed in the hope that it will be useful,\n', '// but WITHOUT ANY WARRANTY; without even the implied warranty of\n', '// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the\n', '// GNU Affero General Public License for more details.\n', '//\n', '// You should have received a copy of the GNU Affero General Public License\n', '// along with this program.  If not, see <https://www.gnu.org/licenses/>.\n', '\n', 'pragma solidity 0.5.12;\n', '\n', 'interface DSPauseAbstract {\n', '    function delay() external view returns (uint256);\n', '    function plot(address, bytes32, bytes calldata, uint256) external;\n', '    function exec(address, bytes32, bytes calldata, uint256) external returns (bytes memory);\n', '}\n', '\n', 'interface CatAbstract {\n', '    function rely(address) external;\n', '    function file(bytes32, bytes32, uint256) external;\n', '    function file(bytes32, bytes32, address) external;\n', '}\n', '\n', 'interface FlipAbstract {\n', '    function rely(address usr) external;\n', '    function vat() external view returns (address);\n', '    function cat() external view returns (address);\n', '    function ilk() external view returns (bytes32);\n', '    function file(bytes32, uint256) external;\n', '}\n', '\n', 'interface IlkRegistryAbstract {\n', '    function add(address) external;\n', '}\n', '\n', 'interface GemJoinAbstract {\n', '    function vat() external view returns (address);\n', '    function ilk() external view returns (bytes32);\n', '    function gem() external view returns (address);\n', '    function dec() external view returns (uint256);\n', '}\n', '\n', 'interface JugAbstract {\n', '    function init(bytes32) external;\n', '    function file(bytes32, bytes32, uint256) external;\n', '}\n', '\n', 'interface MedianAbstract {\n', '    function kiss(address) external;\n', '}\n', '\n', 'interface OsmAbstract {\n', '    function rely(address) external;\n', '    function src() external view returns (address);\n', '    function kiss(address) external;\n', '}\n', '\n', 'interface OsmMomAbstract {\n', '    function setOsm(bytes32, address) external;\n', '}\n', '\n', 'interface SpotAbstract {\n', '    function file(bytes32, bytes32, address) external;\n', '    function file(bytes32, bytes32, uint256) external;\n', '    function poke(bytes32) external;\n', '}\n', '\n', 'interface VatAbstract {\n', '    function rely(address) external;\n', '    function init(bytes32) external;\n', '    function file(bytes32, uint256) external;\n', '    function file(bytes32, bytes32, uint256) external;\n', '}\n', '\n', 'contract SpellAction {\n', '    // MAINNET ADDRESSES\n', '    //\n', '    // The contracts in this list should correspond to MCD core contracts, verify\n', '    //  against the current release list at:\n', '    //     https://changelog.makerdao.com/releases/mainnet/1.1.1/contracts.json\n', '\n', '    address constant MCD_VAT         = 0x35D1b3F3D7966A1DFe207aa4514C12a259A0492B;\n', '    address constant MCD_CAT         = 0xa5679C04fc3d9d8b0AaB1F0ab83555b301cA70Ea;\n', '    address constant MCD_JUG         = 0x19c0976f590D67707E62397C87829d896Dc0f1F1;\n', '    address constant MCD_SPOT        = 0x65C79fcB50Ca1594B025960e539eD7A9a6D434A3;\n', '    address constant MCD_POT         = 0x197E90f9FAD81970bA7976f33CbD77088E5D7cf7;\n', '    address constant MCD_END         = 0xaB14d3CE3F733CACB76eC2AbE7d2fcb00c99F3d5;\n', '    address constant FLIPPER_MOM     = 0xc4bE7F74Ee3743bDEd8E0fA218ee5cf06397f472;\n', '    address constant OSM_MOM         = 0x76416A4d5190d071bfed309861527431304aA14f;\n', '    address constant ILK_REGISTRY    = 0x8b4ce5DCbb01e0e1f0521cd8dCfb31B308E52c24;\n', '\n', '    // COMP-A specific addresses\n', '    address constant COMP            = 0xc00e94Cb662C3520282E6f5717214004A7f26888;\n', '    address constant MCD_JOIN_COMP_A = 0xBEa7cDfB4b49EC154Ae1c0D731E4DC773A3265aA;\n', '    address constant MCD_FLIP_COMP_A = 0x524826F84cB3A19B6593370a5889A58c00554739;\n', '    address constant PIP_COMP        = 0xBED0879953E633135a48a157718Aa791AC0108E4;\n', '\n', '    // LRC-A specific addresses\n', '    address constant LRC             = 0xBBbbCA6A901c926F240b89EacB641d8Aec7AEafD;\n', '    address constant MCD_JOIN_LRC_A  = 0x6C186404A7A238D3d6027C0299D1822c1cf5d8f1;\n', '    address constant MCD_FLIP_LRC_A  = 0x7FdDc36dcdC435D8F54FDCB3748adcbBF70f3dAC;\n', '    address constant PIP_LRC         = 0x9eb923339c24c40Bef2f4AF4961742AA7C23EF3a;\n', '\n', '    // LINK-A specific addresses\n', '    address constant LINK            = 0x514910771AF9Ca656af840dff83E8264EcF986CA;\n', '    address constant MCD_JOIN_LINK_A = 0xdFccAf8fDbD2F4805C174f856a317765B49E4a50;\n', '    address constant MCD_FLIP_LINK_A = 0xB907EEdD63a30A3381E6D898e5815Ee8c9fd2c85;\n', '    address constant PIP_LINK        = 0x9B0C694C6939b5EA9584e9b61C7815E8d97D9cC7;\n', '\n', '    // Decimals & precision\n', '    uint256 constant THOUSAND = 10 ** 3;\n', '    uint256 constant MILLION  = 10 ** 6;\n', '    uint256 constant WAD      = 10 ** 18;\n', '    uint256 constant RAY      = 10 ** 27;\n', '    uint256 constant RAD      = 10 ** 45;\n', '\n', '    // Many of the settings that change weekly rely on the rate accumulator\n', '    // described at https://docs.makerdao.com/smart-contract-modules/rates-module\n', '    // To check this yourself, use the following rate calculation (example 8%):\n', '    //\n', "    // $ bc -l <<< 'scale=27; e( l(1.01)/(60 * 60 * 24 * 365) )'\n", '    //\n', '    uint256 constant    TWO_TWENTYFIVE_PERCENT_RATE = 1000000000705562181084137268;\n', '    uint256 constant  THREE_TWENTYFIVE_PERCENT_RATE = 1000000001014175731521720677;\n', '\n', '    function execute() external {\n', '        // Set the global debt ceiling to 1,416,000,000\n', '        // 1,401 (current DC) + 7 (COMP-A) + 3 (LRC-A) + 5 (LINK-A)\n', '        VatAbstract(MCD_VAT).file("Line", 1416 * MILLION * RAD);\n', '\n', '        /************************************/\n', '        /*** COMP-A COLLATERAL ONBOARDING ***/\n', '        /************************************/\n', '        // Set ilk bytes32 variable\n', '        bytes32 ilk = "COMP-A";\n', '\n', '        // Sanity checks\n', '        require(GemJoinAbstract(MCD_JOIN_COMP_A).vat() == MCD_VAT, "join-vat-not-match");\n', '        require(GemJoinAbstract(MCD_JOIN_COMP_A).ilk() == ilk,     "join-ilk-not-match");\n', '        require(GemJoinAbstract(MCD_JOIN_COMP_A).gem() == COMP,    "join-gem-not-match");\n', '        require(GemJoinAbstract(MCD_JOIN_COMP_A).dec() == 18,      "join-dec-not-match");\n', '        require(FlipAbstract(MCD_FLIP_COMP_A).vat() == MCD_VAT,    "flip-vat-not-match");\n', '        require(FlipAbstract(MCD_FLIP_COMP_A).cat() == MCD_CAT,    "flip-cat-not-match");\n', '        require(FlipAbstract(MCD_FLIP_COMP_A).ilk() == ilk,        "flip-ilk-not-match");\n', '\n', '        // Set the COMP PIP in the Spotter\n', '        SpotAbstract(MCD_SPOT).file(ilk, "pip", PIP_COMP);\n', '\n', '        // Set the COMP-A Flipper in the Cat\n', '        CatAbstract(MCD_CAT).file(ilk, "flip", MCD_FLIP_COMP_A);\n', '\n', '        // Init COMP-A ilk in Vat & Jug\n', '        VatAbstract(MCD_VAT).init(ilk);\n', '        JugAbstract(MCD_JUG).init(ilk);\n', '\n', '        // Allow COMP-A Join to modify Vat registry\n', '        VatAbstract(MCD_VAT).rely(MCD_JOIN_COMP_A);\n', '        // Allow the COMP-A Flipper to reduce the Cat litterbox on deal()\n', '        CatAbstract(MCD_CAT).rely(MCD_FLIP_COMP_A);\n', '        // Allow Cat to kick auctions in COMP-A Flipper\n', '        FlipAbstract(MCD_FLIP_COMP_A).rely(MCD_CAT);\n', '        // Allow End to yank auctions in COMP-A Flipper\n', '        FlipAbstract(MCD_FLIP_COMP_A).rely(MCD_END);\n', '        // Allow FlipperMom to access to the COMP-A Flipper\n', '        FlipAbstract(MCD_FLIP_COMP_A).rely(FLIPPER_MOM);\n', '\n', '        // Allow OsmMom to access to the COMP Osm\n', '        OsmAbstract(PIP_COMP).rely(OSM_MOM);\n', '        // Whitelist Osm to read the Median data (only necessary if it is the first time the token is being added to an ilk)\n', '        MedianAbstract(OsmAbstract(PIP_COMP).src()).kiss(PIP_COMP);\n', '        // Whitelist Spotter to read the Osm data (only necessary if it is the first time the token is being added to an ilk)\n', '        OsmAbstract(PIP_COMP).kiss(MCD_SPOT);\n', '        // Whitelist End to read the Osm data (only necessary if it is the first time the token is being added to an ilk)\n', '        OsmAbstract(PIP_COMP).kiss(MCD_END);\n', '        // Set COMP Osm in the OsmMom for new ilk\n', '        OsmMomAbstract(OSM_MOM).setOsm(ilk, PIP_COMP);\n', '\n', '        // Set the COMP-A debt ceiling\n', '        VatAbstract(MCD_VAT).file(ilk, "line", 7 * MILLION * RAD);\n', '        // Set the COMP-A dust\n', '        VatAbstract(MCD_VAT).file(ilk, "dust", 100 * RAD);\n', '        // Set the COMP-A dunk\n', '        CatAbstract(MCD_CAT).file(ilk, "dunk", 50 * THOUSAND * RAD);\n', '        // Set the COMP-A liquidation penalty \n', '        CatAbstract(MCD_CAT).file(ilk, "chop", 113 * WAD / 100);\n', '        // Set the COMP-A stability fee \n', '        JugAbstract(MCD_JUG).file(ilk, "duty", THREE_TWENTYFIVE_PERCENT_RATE);\n', '        // Set the COMP-A percentage between bids \n', '        FlipAbstract(MCD_FLIP_COMP_A).file("beg", 103 * WAD / 100);\n', '        // Set the COMP-A time max time between bids\n', '        FlipAbstract(MCD_FLIP_COMP_A).file("ttl", 6 hours);\n', '        // Set the COMP-A max auction duration to\n', '        FlipAbstract(MCD_FLIP_COMP_A).file("tau", 6 hours);\n', '        // Set the COMP-A min collateralization ratio \n', '        SpotAbstract(MCD_SPOT).file(ilk, "mat", 175 * RAY / 100);\n', '\n', '        // Update COMP-A spot value in Vat\n', '        SpotAbstract(MCD_SPOT).poke(ilk);\n', '\n', '        // Add new ilk to the IlkRegistry\n', '        IlkRegistryAbstract(ILK_REGISTRY).add(MCD_JOIN_COMP_A);\n', '\n', '        /***********************************/\n', '        /*** LRC-A COLLATERAL ONBOARDING ***/\n', '        /***********************************/\n', '        // Set ilk bytes32 variable\n', '        ilk = "LRC-A";\n', '\n', '        // Sanity checks\n', '        require(GemJoinAbstract(MCD_JOIN_LRC_A).vat() == MCD_VAT, "join-vat-not-match");\n', '        require(GemJoinAbstract(MCD_JOIN_LRC_A).ilk() == ilk,     "join-ilk-not-match");\n', '        require(GemJoinAbstract(MCD_JOIN_LRC_A).gem() == LRC,     "join-gem-not-match");\n', '        require(GemJoinAbstract(MCD_JOIN_LRC_A).dec() == 18,      "join-dec-not-match");\n', '        require(FlipAbstract(MCD_FLIP_LRC_A).vat() == MCD_VAT,    "flip-vat-not-match");\n', '        require(FlipAbstract(MCD_FLIP_LRC_A).cat() == MCD_CAT,    "flip-cat-not-match");\n', '        require(FlipAbstract(MCD_FLIP_LRC_A).ilk() == ilk,        "flip-ilk-not-match");\n', '\n', '        // Set the LRC PIP in the Spotter\n', '        SpotAbstract(MCD_SPOT).file(ilk, "pip", PIP_LRC);\n', '\n', '        // Set the LRC-A Flipper in the Cat\n', '        CatAbstract(MCD_CAT).file(ilk, "flip", MCD_FLIP_LRC_A);\n', '\n', '        // Init LRC-A ilk in Vat & Jug\n', '        VatAbstract(MCD_VAT).init(ilk);\n', '        JugAbstract(MCD_JUG).init(ilk);\n', '\n', '        // Allow LRC-A Join to modify Vat registry\n', '        VatAbstract(MCD_VAT).rely(MCD_JOIN_LRC_A);\n', '        // Allow the LRC-A Flipper to reduce the Cat litterbox on deal()\n', '        CatAbstract(MCD_CAT).rely(MCD_FLIP_LRC_A);\n', '        // Allow Cat to kick auctions in LRC-A Flipper\n', '        FlipAbstract(MCD_FLIP_LRC_A).rely(MCD_CAT);\n', '        // Allow End to yank auctions in LRC-A Flipper\n', '        FlipAbstract(MCD_FLIP_LRC_A).rely(MCD_END);\n', '        // Allow FlipperMom to access to the LRC-A Flipper\n', '        FlipAbstract(MCD_FLIP_LRC_A).rely(FLIPPER_MOM);\n', '\n', '        // Allow OsmMom to access to the LRC Osm\n', '        OsmAbstract(PIP_LRC).rely(OSM_MOM);\n', '        // Whitelist Osm to read the Median data (only necessary if it is the first time the token is being added to an ilk)\n', '        MedianAbstract(OsmAbstract(PIP_LRC).src()).kiss(PIP_LRC);\n', '        // Whitelist Spotter to read the Osm data (only necessary if it is the first time the token is being added to an ilk)\n', '        OsmAbstract(PIP_LRC).kiss(MCD_SPOT);\n', '        // Whitelist End to read the Osm data (only necessary if it is the first time the token is being added to an ilk)\n', '        OsmAbstract(PIP_LRC).kiss(MCD_END);\n', '        // Set LRC Osm in the OsmMom for new ilk\n', '        OsmMomAbstract(OSM_MOM).setOsm(ilk, PIP_LRC);\n', '\n', '        // Set the LRC-A debt ceiling\n', '        VatAbstract(MCD_VAT).file(ilk, "line", 3 * MILLION * RAD);\n', '        // Set the LRC-A dust\n', '        VatAbstract(MCD_VAT).file(ilk, "dust", 100 * RAD);\n', '        // Set the LRC-A dunk\n', '        CatAbstract(MCD_CAT).file(ilk, "dunk", 50 * THOUSAND * RAD);\n', '        // Set the LRC-A liquidation penalty \n', '        CatAbstract(MCD_CAT).file(ilk, "chop", 113 * WAD / 100);\n', '        // Set the LRC-A stability fee \n', '        JugAbstract(MCD_JUG).file(ilk, "duty", THREE_TWENTYFIVE_PERCENT_RATE);\n', '        // Set the LRC-A percentage between bids \n', '        FlipAbstract(MCD_FLIP_LRC_A).file("beg", 103 * WAD / 100);\n', '        // Set the LRC-A time max time between bids\n', '        FlipAbstract(MCD_FLIP_LRC_A).file("ttl", 6 hours);\n', '        // Set the LRC-A max auction duration to\n', '        FlipAbstract(MCD_FLIP_LRC_A).file("tau", 6 hours);\n', '        // Set the LRC-A min collateralization ratio \n', '        SpotAbstract(MCD_SPOT).file(ilk, "mat", 175 * RAY / 100);\n', '\n', '        // Update LRC-A spot value in Vat\n', '        SpotAbstract(MCD_SPOT).poke(ilk);\n', '\n', '        // Add new ilk to the IlkRegistry\n', '        IlkRegistryAbstract(ILK_REGISTRY).add(MCD_JOIN_LRC_A);\n', '\n', '        /************************************/\n', '        /*** LINK-A COLLATERAL ONBOARDING ***/\n', '        /************************************/\n', '        // Set ilk bytes32 variable\n', '        ilk = "LINK-A";\n', '\n', '        // Sanity checks\n', '        require(GemJoinAbstract(MCD_JOIN_LINK_A).vat() == MCD_VAT, "join-vat-not-match");\n', '        require(GemJoinAbstract(MCD_JOIN_LINK_A).ilk() == ilk,     "join-ilk-not-match");\n', '        require(GemJoinAbstract(MCD_JOIN_LINK_A).gem() == LINK,    "join-gem-not-match");\n', '        require(GemJoinAbstract(MCD_JOIN_LINK_A).dec() == 18,      "join-dec-not-match");\n', '        require(FlipAbstract(MCD_FLIP_LINK_A).vat() == MCD_VAT,    "flip-vat-not-match");\n', '        require(FlipAbstract(MCD_FLIP_LINK_A).cat() == MCD_CAT,    "flip-cat-not-match");\n', '        require(FlipAbstract(MCD_FLIP_LINK_A).ilk() == ilk,        "flip-ilk-not-match");\n', '\n', '        // Set the LINK PIP in the Spotter\n', '        SpotAbstract(MCD_SPOT).file(ilk, "pip", PIP_LINK);\n', '\n', '        // Set the LINK-A Flipper in the Cat\n', '        CatAbstract(MCD_CAT).file(ilk, "flip", MCD_FLIP_LINK_A);\n', '\n', '        // Init LINK-A ilk in Vat & Jug\n', '        VatAbstract(MCD_VAT).init(ilk);\n', '        JugAbstract(MCD_JUG).init(ilk);\n', '\n', '        // Allow LINK-A Join to modify Vat registry\n', '        VatAbstract(MCD_VAT).rely(MCD_JOIN_LINK_A);\n', '        // Allow the LINK-A Flipper to reduce the Cat litterbox on deal()\n', '        CatAbstract(MCD_CAT).rely(MCD_FLIP_LINK_A);\n', '        // Allow Cat to kick auctions in LINK-A Flipper\n', '        FlipAbstract(MCD_FLIP_LINK_A).rely(MCD_CAT);\n', '        // Allow End to yank auctions in LINK-A Flipper\n', '        FlipAbstract(MCD_FLIP_LINK_A).rely(MCD_END);\n', '        // Allow FlipperMom to access to the LINK-A Flipper\n', '        FlipAbstract(MCD_FLIP_LINK_A).rely(FLIPPER_MOM);\n', '\n', '        // Allow OsmMom to access to the LINK Osm\n', '        OsmAbstract(PIP_LINK).rely(OSM_MOM);\n', '        // Whitelist Osm to read the Median data (only necessary if it is the first time the token is being added to an ilk)\n', '        MedianAbstract(OsmAbstract(PIP_LINK).src()).kiss(PIP_LINK);\n', '        // Whitelist Spotter to read the Osm data (only necessary if it is the first time the token is being added to an ilk)\n', '        OsmAbstract(PIP_LINK).kiss(MCD_SPOT);\n', '        // Whitelist End to read the Osm data (only necessary if it is the first time the token is being added to an ilk)\n', '        OsmAbstract(PIP_LINK).kiss(MCD_END);\n', '        // Set LINK Osm in the OsmMom for new ilk\n', '        OsmMomAbstract(OSM_MOM).setOsm(ilk, PIP_LINK);\n', '\n', '        // Set the LINK-A debt ceiling\n', '        VatAbstract(MCD_VAT).file(ilk, "line", 5 * MILLION * RAD);\n', '        // Set the LINK-A dust\n', '        VatAbstract(MCD_VAT).file(ilk, "dust", 100 * RAD);\n', '        // Set the LINK-A dunk\n', '        CatAbstract(MCD_CAT).file(ilk, "dunk", 50 * THOUSAND * RAD);\n', '        // Set the LINK-A liquidation penalty \n', '        CatAbstract(MCD_CAT).file(ilk, "chop", 113 * WAD / 100);\n', '        // Set the LINK-A stability fee \n', '        JugAbstract(MCD_JUG).file(ilk, "duty", TWO_TWENTYFIVE_PERCENT_RATE);\n', '        // Set the LINK-A percentage between bids \n', '        FlipAbstract(MCD_FLIP_LINK_A).file("beg", 103 * WAD / 100);\n', '        // Set the LINK-A time max time between bids\n', '        FlipAbstract(MCD_FLIP_LINK_A).file("ttl", 6 hours);\n', '        // Set the LINK-A max auction duration to\n', '        FlipAbstract(MCD_FLIP_LINK_A).file("tau", 6 hours);\n', '        // Set the LINK-A min collateralization ratio \n', '        SpotAbstract(MCD_SPOT).file(ilk, "mat", 175 * RAY / 100);\n', '\n', '        // Update LINK-A spot value in Vat\n', '        SpotAbstract(MCD_SPOT).poke(ilk);\n', '\n', '        // Add new ilk to the IlkRegistry\n', '        IlkRegistryAbstract(ILK_REGISTRY).add(MCD_JOIN_LINK_A);\n', '    }\n', '}\n', '\n', 'contract DssSpell {\n', '    DSPauseAbstract public pause =\n', '        DSPauseAbstract(0xbE286431454714F511008713973d3B053A2d38f3);\n', '    address         public action;\n', '    bytes32         public tag;\n', '    uint256         public eta;\n', '    bytes           public sig;\n', '    uint256         public expiration;\n', '    bool            public done;\n', '\n', '\n', '    // Provides a descriptive tag for bot consumption\n', '    // This should be modified weekly to provide a summary of the actions\n', '    // Hash: seth keccak -- "$(wget https://raw.githubusercontent.com/makerdao/community/8980cdc055642f8aa56756d39606cc55bfe7caf6/governance/votes/Executive%20vote%20-%20September%2028%2C%202020.md -q -O - 2>/dev/null)"\n', '    string constant public description =\n', '        "2020-09-28 MakerDAO Executive Spell | Hash: 0xc19a4f25cf049ac24f56e5fd042d95691de62e583f238279752db1ad516d4e99";\n', '\n', '    // MIP15: Dark Spell Mechanism\n', '    // Hash: seth keccak -- "$(wget https://raw.githubusercontent.com/makerdao/mips/eb6d36a1007ded0a5126181f5a86276ea78a91d3/MIP15/mip15.md -q -O - 2>/dev/null)"\n', '    string constant public MIP15 = "0x081b03146714fbba3d6ed78b59fef50577adb87f33d214d68639d917be794726";\n', '\n', '    // MIP12c2-SP4: LRC Collateral Onboarding\n', '    // Hash: seth keccak -- "$(wget https://raw.githubusercontent.com/makerdao/mips/eb6d36a1007ded0a5126181f5a86276ea78a91d3/MIP12/MIP12c2-Subproposals/MIP12c2-SP4.md -q -O - 2>/dev/null)"\n', '    string constant public MIP12c2SP4 = "0x43d4abcabb8838f7708ebe51ff35fd6655ba7153006906388898615ac082a87d";\n', '\n', '    // MIP12c2-SP5: COMP Collateral Onboarding\n', '    // Hash: seth keccak -- "$(wget https://raw.githubusercontent.com/makerdao/mips/eb6d36a1007ded0a5126181f5a86276ea78a91d3/MIP12/MIP12c2-Subproposals/MIP12c2-SP5.md -q -O - 2>/dev/null)"\n', '    string constant public MIP12c2SP5 = "0xdb6c5e10409435219e99b37ef1ec18f1d265246d1e4e8d2dcca14ed86513fe38";\n', '\n', '    // MIP12c2-SP6: LINK Collateral Onboarding\n', '    // Hash: seth keccak -- "$(wget https://raw.githubusercontent.com/makerdao/mips/eb6d36a1007ded0a5126181f5a86276ea78a91d3/MIP12/MIP12c2-Subproposals/MIP12c2-SP6.md -q -O - 2>/dev/null)"\n', '    string constant public MIP12c2SP6 = "0x05896bb330f113b498c2d84c9c120d7e0cd65609b064895dd2b550162211221d";\n', '\n', '    // MIP7c3-SP3: Domain Team Onboarding (Risk Domain Team)\n', '    // Hash: seth keccak -- "$(wget https://raw.githubusercontent.com/makerdao/mips/eb6d36a1007ded0a5126181f5a86276ea78a91d3/MIP7/MIP7c3-Subproposals/MIP7c3-SP3.md -q -O - 2>/dev/null)"\n', '    string constant public MIP7c3SP3 = "0x75dff1d98dc14ddc85c4325fb75ce14f06857f5f09b0e321df91f4416f29ba7c";\n', '\n', '    // MIP7c3-SP4: Subproposal Template for Smart Contracts Domain Team Onboarding\n', '    // Hash: seth keccak -- "$(wget https://raw.githubusercontent.com/makerdao/mips/eb6d36a1007ded0a5126181f5a86276ea78a91d3/MIP7/MIP7c3-Subproposals/MIP7c3-SP4.md -q -O - 2>/dev/null)"\n', '    string constant public MIP7c3SP4 = "0x6ee0230b3ec6f25bb4c59b295ce8650db2400919fe6c4aae2bf1255106c621e4";\n', '\n', '    // MIP13c3-SP2: Declaration of Intent - Dai Flash Mint Module\n', '    // Hash: seth keccak -- "$(wget https://raw.githubusercontent.com/makerdao/mips/eb6d36a1007ded0a5126181f5a86276ea78a91d3/MIP13/MIP13c3-Subproposals/MIP13c3-SP2.md -q -O - 2>/dev/null)"\n', '    string constant public MIP13c3SP2 = "0x6e2a266ed710c4a6999c91833d04e195f3bcbc29cff7bf252cb112241400cc43";\n', '\n', '    constructor() public {\n', '        sig = abi.encodeWithSignature("execute()");\n', '        action = address(new SpellAction());\n', '        bytes32 _tag;\n', '        address _action = action;\n', '        assembly { _tag := extcodehash(_action) }\n', '        tag = _tag;\n', '        expiration = now + 4 days + 2 hours;\n', '    }\n', '\n', '    modifier officeHours {\n', '        uint day = (now / 1 days + 3) % 7;\n', '        require(day < 5, "Can only be cast on a weekday");\n', '        uint hour = now / 1 hours % 24;\n', '        require(hour >= 14 && hour < 21, "Outside office hours");\n', '        _;\n', '    }\n', '\n', '    function schedule() public {\n', '        require(now <= expiration, "This contract has expired");\n', '        require(eta == 0, "This spell has already been scheduled");\n', '        eta = now + DSPauseAbstract(pause).delay();\n', '        pause.plot(action, tag, sig, eta);\n', '    }\n', '\n', '    function cast() public officeHours {\n', '        require(!done, "spell-already-cast");\n', '        done = true;\n', '        pause.exec(action, tag, sig, eta);\n', '    }\n', '}']