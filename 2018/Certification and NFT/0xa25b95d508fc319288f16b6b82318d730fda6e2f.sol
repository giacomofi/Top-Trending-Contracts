['//distribute tokens\n', 'pragma solidity ^0.4.24;\n', '\n', 'contract U42 {\n', '\tfunction transferFrom (address _from, address _to, uint256 _value ) public returns ( bool );\n', '}\n', '\n', 'contract U42_Dist4 {\n', '\n', '\tconstructor() public {\n', '\t\t//nothing to do\n', '\t}\n', '\n', '\tfunction dist (address _tokenContractAddress) public returns (bool success) {\n', '\t\tU42 target = U42(_tokenContractAddress);\n', '\n', '\t\t//batch 4 -- 26 items\n', '\t\ttarget.transferFrom(msg.sender, 0x8F7fD445afa5203EfaF7033683BfbE198e6cFFa2, 125188000000000000000000);\n', '\t\ttarget.transferFrom(msg.sender, 0x40c53B223cdD152129C394465d338c5D57306Ab4, 228850000000000000000);\n', '\t\ttarget.transferFrom(msg.sender, 0xD65D398f500C4ABc8313fF132814Ef173F57850E, 250000000000000000000000);\n', '\t\ttarget.transferFrom(msg.sender, 0xc9c7F168985EC5D534760DaC313458D982B41784, 448938000000000000000000);\n', '\t\ttarget.transferFrom(msg.sender, 0x970c8a756DaB5bAF3Ea4bd59D251ded2DAB599ac, 82500000000000000000000);\n', '\t\ttarget.transferFrom(msg.sender, 0x1A35645dE121Aa895B46215739fEC495387D2E34, 2500000000000000000000);\n', '\t\ttarget.transferFrom(msg.sender, 0x9ebD57aca9209217E7103ce7d7c22d7e2cc1596E, 3750000000000000000000);\n', '\t\ttarget.transferFrom(msg.sender, 0x6c8533A1dc88BF3257957AC0a0a92C9d609bFcd6, 20750000000000000000000);\n', '\t\ttarget.transferFrom(msg.sender, 0x475af41014f1A06aB40B5eb57f527A1D010Ca2cd, 2500000000000000000000);\n', '\t\ttarget.transferFrom(msg.sender, 0xB99fe9D76C2a223515dEE9Feb450C55A91e93b5B, 258750000000000000000);\n', '\t\ttarget.transferFrom(msg.sender, 0x7cEAc53Ce8107E32bb24315b79ecC5e5EA699E09, 2500000000000000000000);\n', '\t\ttarget.transferFrom(msg.sender, 0xe5eb9327bEf6781C464c5636d7F96afeAF9D3Bc8, 265787000000000000000000);\n', '\t\ttarget.transferFrom(msg.sender, 0xDf5481B6A93a1630B51a7240455c53FF641e03bf, 1626575000000000000000000);\n', '\t\ttarget.transferFrom(msg.sender, 0x9C4d5a183fb96Ba8556058c4286608a433d26Fd5, 2500000000000000000000);\n', '\t\ttarget.transferFrom(msg.sender, 0x08b1D9b4Ab62b170eA81fa1A12080D84933EFAB2, 250239000000000000000000);\n', '\t\ttarget.transferFrom(msg.sender, 0x956D26291dD758D7A4E4922F65E3C8B18B5650DF, 1152300000000000000000);\n', '\t\ttarget.transferFrom(msg.sender, 0x2ebd9a092515178166eDF34a1aE1503979c58E4b, 37500000000000000000000);\n', '\t\ttarget.transferFrom(msg.sender, 0x84afd9Dc2CAC0ff868E9225D2A9Bb4A7D157E561, 1335958000000000000000000);\n', '\t\ttarget.transferFrom(msg.sender, 0xDDfF36f9099fe31316F35e3877efcB0134E516B1, 401685000000000000000000);\n', '\t\ttarget.transferFrom(msg.sender, 0x7127641927d96b06B5c7c455B76CDf8370010f8e, 1082465000000000000000000);\n', '\t\ttarget.transferFrom(msg.sender, 0x4c4af6881Db7a4e278e5868571276B25179Bdcfb, 37500000000000000000000);\n', '\t\ttarget.transferFrom(msg.sender, 0x9Ecb0b26b218c289151Bc250E94f90AAB0F0eEA7, 154561000000000000000000);\n', '\t\ttarget.transferFrom(msg.sender, 0x777FFDAD4ED2eaBeB7a3daB851e8539436861c96, 2500000000000000000000);\n', '\t\ttarget.transferFrom(msg.sender, 0xFe53A75Ec66b8eb720E968F4276Ab4b10999Ad73, 25000000000000000000000);\n', '\t\ttarget.transferFrom(msg.sender, 0xDba3F1F4452a89ED84E3a06aEFF19A805f20A97C, 1961044000000000000000000);\n', '\t\ttarget.transferFrom(msg.sender, 0x37C3c0638883c604d857A0f5dEFc42CB054d51d0, 9950000000000000000000);\n', '\t\t//end of batch 4 -- 26 items\n', '\n', '\t\treturn true;\n', '\t}\n', '}']
['//distribute tokens\n', 'pragma solidity ^0.4.24;\n', '\n', 'contract U42 {\n', '\tfunction transferFrom (address _from, address _to, uint256 _value ) public returns ( bool );\n', '}\n', '\n', 'contract U42_Dist4 {\n', '\n', '\tconstructor() public {\n', '\t\t//nothing to do\n', '\t}\n', '\n', '\tfunction dist (address _tokenContractAddress) public returns (bool success) {\n', '\t\tU42 target = U42(_tokenContractAddress);\n', '\n', '\t\t//batch 4 -- 26 items\n', '\t\ttarget.transferFrom(msg.sender, 0x8F7fD445afa5203EfaF7033683BfbE198e6cFFa2, 125188000000000000000000);\n', '\t\ttarget.transferFrom(msg.sender, 0x40c53B223cdD152129C394465d338c5D57306Ab4, 228850000000000000000);\n', '\t\ttarget.transferFrom(msg.sender, 0xD65D398f500C4ABc8313fF132814Ef173F57850E, 250000000000000000000000);\n', '\t\ttarget.transferFrom(msg.sender, 0xc9c7F168985EC5D534760DaC313458D982B41784, 448938000000000000000000);\n', '\t\ttarget.transferFrom(msg.sender, 0x970c8a756DaB5bAF3Ea4bd59D251ded2DAB599ac, 82500000000000000000000);\n', '\t\ttarget.transferFrom(msg.sender, 0x1A35645dE121Aa895B46215739fEC495387D2E34, 2500000000000000000000);\n', '\t\ttarget.transferFrom(msg.sender, 0x9ebD57aca9209217E7103ce7d7c22d7e2cc1596E, 3750000000000000000000);\n', '\t\ttarget.transferFrom(msg.sender, 0x6c8533A1dc88BF3257957AC0a0a92C9d609bFcd6, 20750000000000000000000);\n', '\t\ttarget.transferFrom(msg.sender, 0x475af41014f1A06aB40B5eb57f527A1D010Ca2cd, 2500000000000000000000);\n', '\t\ttarget.transferFrom(msg.sender, 0xB99fe9D76C2a223515dEE9Feb450C55A91e93b5B, 258750000000000000000);\n', '\t\ttarget.transferFrom(msg.sender, 0x7cEAc53Ce8107E32bb24315b79ecC5e5EA699E09, 2500000000000000000000);\n', '\t\ttarget.transferFrom(msg.sender, 0xe5eb9327bEf6781C464c5636d7F96afeAF9D3Bc8, 265787000000000000000000);\n', '\t\ttarget.transferFrom(msg.sender, 0xDf5481B6A93a1630B51a7240455c53FF641e03bf, 1626575000000000000000000);\n', '\t\ttarget.transferFrom(msg.sender, 0x9C4d5a183fb96Ba8556058c4286608a433d26Fd5, 2500000000000000000000);\n', '\t\ttarget.transferFrom(msg.sender, 0x08b1D9b4Ab62b170eA81fa1A12080D84933EFAB2, 250239000000000000000000);\n', '\t\ttarget.transferFrom(msg.sender, 0x956D26291dD758D7A4E4922F65E3C8B18B5650DF, 1152300000000000000000);\n', '\t\ttarget.transferFrom(msg.sender, 0x2ebd9a092515178166eDF34a1aE1503979c58E4b, 37500000000000000000000);\n', '\t\ttarget.transferFrom(msg.sender, 0x84afd9Dc2CAC0ff868E9225D2A9Bb4A7D157E561, 1335958000000000000000000);\n', '\t\ttarget.transferFrom(msg.sender, 0xDDfF36f9099fe31316F35e3877efcB0134E516B1, 401685000000000000000000);\n', '\t\ttarget.transferFrom(msg.sender, 0x7127641927d96b06B5c7c455B76CDf8370010f8e, 1082465000000000000000000);\n', '\t\ttarget.transferFrom(msg.sender, 0x4c4af6881Db7a4e278e5868571276B25179Bdcfb, 37500000000000000000000);\n', '\t\ttarget.transferFrom(msg.sender, 0x9Ecb0b26b218c289151Bc250E94f90AAB0F0eEA7, 154561000000000000000000);\n', '\t\ttarget.transferFrom(msg.sender, 0x777FFDAD4ED2eaBeB7a3daB851e8539436861c96, 2500000000000000000000);\n', '\t\ttarget.transferFrom(msg.sender, 0xFe53A75Ec66b8eb720E968F4276Ab4b10999Ad73, 25000000000000000000000);\n', '\t\ttarget.transferFrom(msg.sender, 0xDba3F1F4452a89ED84E3a06aEFF19A805f20A97C, 1961044000000000000000000);\n', '\t\ttarget.transferFrom(msg.sender, 0x37C3c0638883c604d857A0f5dEFc42CB054d51d0, 9950000000000000000000);\n', '\t\t//end of batch 4 -- 26 items\n', '\n', '\t\treturn true;\n', '\t}\n', '}']