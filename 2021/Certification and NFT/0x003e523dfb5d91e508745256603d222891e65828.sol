['/**\n', ' *Submitted for verification at Etherscan.io on 2021-02-26\n', '*/\n', '\n', '// SPDX-License-Identifier: AGPL-3.0\n', '// The MegaPoker\n', '//\n', '// Copyright (C) 2020 Maker Ecosystem Growth Holdings, INC.\n', '//\n', '// This program is free software: you can redistribute it and/or modify\n', '// it under the terms of the GNU Affero General Public License as published by\n', '// the Free Software Foundation, either version 3 of the License, or\n', '// (at your option) any later version.\n', '//\n', '// This program is distributed in the hope that it will be useful,\n', '// but WITHOUT ANY WARRANTY; without even the implied warranty of\n', '// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the\n', '// GNU Affero General Public License for more details.\n', '//\n', '// You should have received a copy of the GNU Affero General Public License\n', '// along with this program.  If not, see <https://www.gnu.org/licenses/>.\n', '\n', 'pragma solidity ^0.6.11;\n', '\n', 'interface OsmLike {\n', '    function poke() external;\n', '    function pass() external view returns (bool);\n', '}\n', '\n', 'interface SpotLike {\n', '    function poke(bytes32) external;\n', '}\n', '\n', 'contract MegaPoker {\n', '    OsmLike constant eth          = OsmLike(0x81FE72B5A8d1A857d176C3E7d5Bd2679A9B85763);\n', '    OsmLike constant bat          = OsmLike(0xB4eb54AF9Cc7882DF0121d26c5b97E802915ABe6);\n', '    OsmLike constant btc          = OsmLike(0xf185d0682d50819263941e5f4EacC763CC5C6C42);\n', '    OsmLike constant knc          = OsmLike(0xf36B79BD4C0904A5F350F1e4f776B81208c13069);\n', '    OsmLike constant zrx          = OsmLike(0x7382c066801E7Acb2299aC8562847B9883f5CD3c);\n', '    OsmLike constant mana         = OsmLike(0x8067259EA630601f319FccE477977E55C6078C13);\n', '    OsmLike constant usdt         = OsmLike(0x7a5918670B0C390aD25f7beE908c1ACc2d314A3C);\n', '    OsmLike constant comp         = OsmLike(0xBED0879953E633135a48a157718Aa791AC0108E4);\n', '    OsmLike constant link         = OsmLike(0x9B0C694C6939b5EA9584e9b61C7815E8d97D9cC7);\n', '    OsmLike constant lrc          = OsmLike(0x9eb923339c24c40Bef2f4AF4961742AA7C23EF3a);\n', '    OsmLike constant yfi          = OsmLike(0x5F122465bCf86F45922036970Be6DD7F58820214);\n', '    OsmLike constant bal          = OsmLike(0x3ff860c0F28D69F392543A16A397D0dAe85D16dE);\n', '    OsmLike constant uni          = OsmLike(0xf363c7e351C96b910b92b45d34190650df4aE8e7);\n', '    OsmLike constant aave         = OsmLike(0x8Df8f06DC2dE0434db40dcBb32a82A104218754c);\n', '    OsmLike constant univ2daieth  = OsmLike(0x87ecBd742cEB40928E6cDE77B2f0b5CFa3342A09);\n', '    OsmLike constant univ2wbtceth = OsmLike(0x771338D5B31754b25D2eb03Cea676877562Dec26);\n', '    OsmLike constant univ2usdceth = OsmLike(0xECB03Fec701B93DC06d19B4639AA8b5a838472BE);\n', '    OsmLike constant univ2daiusdc = OsmLike(0x25CD858a00146961611b18441353603191f110A0);\n', '    OsmLike constant univ2ethusdt = OsmLike(0x9b015AA3e4787dd0df8B43bF2FE6d90fa543E13B);\n', '    OsmLike constant univ2linketh = OsmLike(0x628009F5F5029544AE84636Ef676D3Cc5755238b);\n', '    OsmLike constant univ2unieth  = OsmLike(0x8Ce9E9442F2791FC63CD6394cC12F2dE4fbc1D71);\n', '    OsmLike constant univ2wbtcdai = OsmLike(0x5FB5a346347ACf4FCD3AAb28f5eE518785FB0AD0);\n', '    OsmLike constant univ2aaveeth = OsmLike(0x8D34DC2c33A6386E96cA562D8478Eaf82305b81a);\n', '    OsmLike constant univ2daiusdt = OsmLike(0x69562A7812830E6854Ffc50b992c2AA861D5C2d3);\n', '    SpotLike constant spot        = SpotLike(0x65C79fcB50Ca1594B025960e539eD7A9a6D434A3);\n', '\n', '    function process() internal {\n', '        if (         eth.pass())           eth.poke();\n', '        if (         bat.pass())           bat.poke();\n', '        if (         btc.pass())           btc.poke();\n', '        if (         knc.pass())           knc.poke();\n', '        if (         zrx.pass())           zrx.poke();\n', '        if (        mana.pass())          mana.poke();\n', '        if (        usdt.pass())          usdt.poke();\n', '        if (        comp.pass())          comp.poke();\n', '        if (        link.pass())          link.poke();\n', '        if (         lrc.pass())           lrc.poke();\n', '        if (         yfi.pass())           yfi.poke();\n', '        if (         bal.pass())           bal.poke();\n', '        if (         uni.pass())           uni.poke();\n', '        if (        aave.pass())          aave.poke();\n', '        if ( univ2daieth.pass())   univ2daieth.poke();\n', '        if (univ2wbtceth.pass())  univ2wbtceth.poke();\n', '        if (univ2usdceth.pass())  univ2usdceth.poke();\n', '        if (univ2daiusdc.pass())  univ2daiusdc.poke();\n', '        if (univ2ethusdt.pass())  univ2ethusdt.poke();\n', '        if (univ2linketh.pass())  univ2linketh.poke();\n', '        if ( univ2unieth.pass())   univ2unieth.poke();\n', '        if (univ2wbtcdai.pass())  univ2wbtcdai.poke();\n', '        if (univ2aaveeth.pass())  univ2aaveeth.poke();\n', '\n', '        spot.poke("ETH-A");\n', '        spot.poke("BAT-A");\n', '        spot.poke("WBTC-A");\n', '        spot.poke("KNC-A");\n', '        spot.poke("ZRX-A");\n', '        spot.poke("MANA-A");\n', '        spot.poke("USDT-A");\n', '        spot.poke("COMP-A");\n', '        spot.poke("LINK-A");\n', '        spot.poke("LRC-A");\n', '        spot.poke("ETH-B");\n', '        spot.poke("YFI-A");\n', '        spot.poke("BAL-A");\n', '        spot.poke("RENBTC-A");\n', '        spot.poke("UNI-A");\n', '        spot.poke("AAVE-A");\n', '        spot.poke("UNIV2DAIETH-A");\n', '        spot.poke("UNIV2WBTCETH-A");\n', '        spot.poke("UNIV2USDCETH-A");\n', '        spot.poke("UNIV2DAIUSDC-A");\n', '        spot.poke("UNIV2ETHUSDT-A");\n', '        spot.poke("UNIV2LINKETH-A");\n', '        spot.poke("UNIV2UNIETH-A");\n', '        spot.poke("UNIV2WBTCDAI-A");\n', '        spot.poke("UNIV2AAVEETH-A");\n', '    }\n', '\n', '    function poke() external {\n', '        process();\n', '\n', '        if (univ2daiusdt.pass())  univ2daiusdt.poke();\n', '\n', '        spot.poke("UNIV2DAIUSDT-A");\n', '    }\n', '\n', '    // Use for poking OSMs prior to collateral being added\n', '    function pokeTemp() external {\n', '        process();\n', '    }\n', '}']