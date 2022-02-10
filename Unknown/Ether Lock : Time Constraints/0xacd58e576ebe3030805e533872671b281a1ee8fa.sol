['pragma solidity ^0.4.10;\n', '\n', 'contract addGenesisPairs {\n', '    \n', 'address[] newParents;\n', 'address[] newChildren;\n', '\n', 'function addGenesisPairs()    {\n', '    // Set elixor contract address\n', '    elixor elixorContract=elixor(0x898bF39cd67658bd63577fB00A2A3571dAecbC53);\n', '    \n', '    newParents=[\n', '0xAAde1b1403782076D5AB3a9473E5106Bd8D0d7B7,\n', '0xE6fD517c42F0C6aF05aF3E547c099F42B13A911e,\n', '0x86F3466884ab2Cf74348A7161eB93925782073C1,\n', '0x49B5ae4d3ea93C26aB36C4Fe0cc552281BC1c42f,\n', '0xAbdF0E5FCbD5619d75538BA7c198729e9c998B4B,\n', '0x3d98eca4a28DeA0BA7973587DdE97584Fd5d1806,\n', '0xa405659357915aC1E6E1C68dcFdf2E79e8ED36ca,\n', '0xE27b5C3fb4eF0777A12af56b79639490150e22cB,\n', '0x013fa2BA246F1b0aD0CeABf783C7E0E5eBF1f248,\n', '0xbf98dcffCC75423B936823f62571d6cd8FD309b2,\n', '0x52E4A0dc1CE8a9d0e894d32A6D4Cb5Eb49BC5778,\n', '0x675FBfB3fD36D1dd4F1496C20f7431D718fc0D38,\n', '0xB882467EB19c0eC6D80a34854Ed1cC06196C49DF,\n', '0x50365F90397C435fa2C03eb0654CD228B14950d9,\n', '0x861eBF9B5EFdeF004Cd377Fb3d600B910f6A496A,\n', '0x17c2f37a623f1B320B97D3F031cE1fb563490c10,\n', '0x13a666eA614d0eE8540CD712c37b499D281223f0,\n', '0x2938B84A22b481189AcFbc01e2740B0ADE33e04D,\n', '0xd0d4a973ec0217Fc4608985BFDc30c74b65B3328,\n', '0x41DC237348c49CD2698b0023Bf8C127BeC67785F,\n', '0x8a86AE785cF3598F1aAc3b9BEC5eb95fC25F8161,\n', '0x22C74B4875311486901A2CFD7D7f58964F5Db0b1,\n', '0x62614d4D3C68D0d80EE88c510d84Cc164C88E8D4,\n', '0x942Abbcc11231337d3D7ADd0a7c8801D0b4F81A8\n', '    ];\n', '    \n', '    \n', '    \n', '    newChildren=[0xe7ae0a04D3b51D4CbdcB5D226aDB4D4b1f3A7278,\n', '0xC32B4b6EFa9a80C744a73B782346E006ea7b4188,\n', '0x617E876094b8f4Cf8ea58453aC472B594908E31D,\n', '0xfA6753935c738B353E0c2F262ae60Cd677AcfFea,\n', '0xb146e21072164CE778C81DE1b20f7bBa4aE3BCc4,\n', '0xF0801a90AE572004dC50a184b3d8f6227DF51B75,\n', '0xcaA7d6A9fE0d5b166AC9c1CccC045DF809db97ab,\n', '0x1D91768FC01b0ccF7beB0b81C31FCc1bC0A47657,\n', '0xfC3B27a53d6a00690c817bc52be28ffa608800EE,\n', '0x400c8c53C0A58E5ebd14817794e66a2B5747f017,\n', '0x4c65897f3bF6923FCd8A42779F22c9B2cfDD3f11,\n', '0xF2eE40C1AC28fD574E9f4BaA688B7196769cFaeD,\n', '0x497FCB2B6538321bE564D4da46BBe589328cB9A6,\n', '0xB72132Ba4FAd953b530A7aebdacE533Ac45c225d,\n', '0x9C40EEe70418e5eb683642ab39E87772cA898101,\n', '0x38d742a044dD8274D587bBa9053DfF74D93472b3,\n', '0x7D8b5Ab1FFA5eAC1b93DB2759D2dB1fCf9Adcb5e,\n', '0x6153006Df7BA15f15D1E68F5d79Ac8cDA3208834,\n', '0xB757631453dca0f5b8Cf67b3489477458465627f,\n', '0xA4ef6924D91FC82756454c934C75dfC5396cd2dd,\n', '0x7484A185970fd63286138F4b40045631dE432030,\n', '0x8503A3067F94845b10d1a196AcB9Aaa1AD7C403b,\n', '0x843e3C1693C35C7fB9A76Fc8b1BbAfF465A58741,\n', '0x43972B936CAB4cA120Aef86d2534a3287F5d6d3b\n', '    ];\n', '    \n', '    elixorContract.importGenesisPairs(newParents,newChildren);\n', ' \n', '}\n', '\n', '}\n', '\n', 'contract elixor {\n', '    function importGenesisPairs(address[] newParents,address[] newChildren) public;\n', '}']