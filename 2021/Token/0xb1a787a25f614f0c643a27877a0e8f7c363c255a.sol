['/**\n', ' *Submitted for verification at Etherscan.io on 2021-04-08\n', '*/\n', '\n', 'pragma solidity ^0.5.15;\n', '\n', '/**\n', ' * @dev Interface of the ERC20 standard as defined in the EIP.\n', ' */\n', 'interface IERC20 {\n', '    /**\n', '     * @dev Returns the amount of tokens in existence.\n', '     */\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    /**\n', '     * @dev Returns the amount of tokens owned by `account`.\n', '     */\n', '    function balanceOf(address account) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Moves `amount` tokens from the caller's account to `recipient`.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Returns the remaining number of tokens that `spender` will be\n', '     * allowed to spend on behalf of `owner` through {transferFrom}. This is\n', '     * zero by default.\n', '     *\n', '     * This value changes when {approve} or {transferFrom} are called.\n', '     */\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * IMPORTANT: Beware that changing an allowance with this method brings the risk\n', '     * that someone may use both the old and the new allowance by unfortunate\n', '     * transaction ordering. One possible solution to mitigate this race\n', "     * condition is to first reduce the spender's allowance to 0 and set the\n", '     * desired value afterwards:\n', '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     *\n', '     * Emits an {Approval} event.\n', '     */\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Moves `amount` tokens from `sender` to `recipient` using the\n', "     * allowance mechanism. `amount` is then deducted from the caller's\n", '     * allowance.\n', '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Emitted when `value` tokens are moved from one account (`from`) to\n', '     * another (`to`).\n', '     *\n', '     * Note that `value` may be zero.\n', '     */\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    /**\n', '     * @dev Emitted when the allowance of a `spender` for an `owner` is set by\n', '     * a call to {approve}. `value` is the new allowance.\n', '     */\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'contract YAMDistributor {\n', '    IERC20 private constant TOKEN =\n', '        IERC20(0x0AaCfbeC6a24756c20D41914F2caba817C0d8521);\n', '\n', '    function execute() external {\n', '        TOKEN.transfer(\n', '            0xdD395050aC923466D3Fa97D41739a4ab6b49E9F5,\n', '            6607578516086512703075\n', '        );\n', '        TOKEN.transfer(\n', '            0x7c21d373E369B6ecC9D418180A07E83DE3493Df7,\n', '            93668371818792883423\n', '        );\n', '        TOKEN.transfer(\n', '            0xdF0259238271427C469ABC18A2CB3047d5c12466,\n', '            123802151257138725095\n', '        );\n', '        TOKEN.transfer(\n', '            0xdB012F63fCAd8765FCd1514ba7fCe621C5577892,\n', '            2329381102654086557913\n', '        );\n', '        TOKEN.transfer(\n', '            0x974678F5aFF73Bf7b5a157883840D752D01f1973,\n', '            131907560714476375160\n', '        );\n', '        TOKEN.transfer(\n', '            0x653d63E4F2D7112a19f5Eb993890a3F27b48aDa5,\n', '            4652319439701607624182\n', '        );\n', '        TOKEN.transfer(\n', '            0x3F3B7D0f3Da05F6Cd44E9D35A9517B59c83AD560,\n', '            85853958748802177113\n', '        );\n', '        TOKEN.transfer(\n', '            0x52331b265Df17B3B4e6253115f488d6d7959Bb9E,\n', '            1650326635832114568108\n', '        );\n', '        TOKEN.transfer(\n', '            0xbdac5657eDd13F47C3DD924eAa36Cf1Ec49672cc,\n', '            196704085295328316497\n', '        );\n', '        TOKEN.transfer(\n', '            0xB1AdceddB2941033a090dD166a462fe1c2029484,\n', '            6892784016785086879385\n', '        );\n', '        TOKEN.transfer(\n', '            0x28AD8E41F950568C6eB15e8426c9760b80BEcaFE,\n', '            447918986748225441642\n', '        );\n', '        TOKEN.transfer(\n', '            0x828CaD2D3A81Cc04425CC73D551211EDda1aB687,\n', '            91801024417848893535\n', '        );\n', '        TOKEN.transfer(\n', '            0x2b19eDb98dF9B54deedC497B2586aA6858F89F01,\n', '            39252172496445630529\n', '        );\n', '        TOKEN.transfer(\n', '            0xA8612C28C8f878Ec80f8A6630796820Ae8C7690E,\n', '            60874295413817430891\n', '        );\n', '        TOKEN.transfer(\n', '            0x7FeD55561afd4760b0bD7EDC5e0312aE6C1AAc98,\n', '            47993121183531240656\n', '        );\n', '        TOKEN.transfer(\n', '            0xcA5db177f54a8D974AeA6A838F0F92489734451C,\n', '            43613522191364627629\n', '        );\n', '        TOKEN.transfer(\n', '            0x40DCBa8E2508DDAa687fc26f9491b8cca563C845,\n', '            56116066106013293076\n', '        );\n', '        TOKEN.transfer(\n', '            0x00dBE6dFc86866B80C930E70111DE8cF4382b824,\n', '            11334328222093368195\n', '        );\n', '        TOKEN.transfer(\n', '            0xaBCB10c500b71B19AdbD339e13C9B5536E261bD9,\n', '            40705953806764915541\n', '        );\n', '        TOKEN.transfer(\n', '            0x97f0978c18DE9B61840d4627040AEA796090343F,\n', '            195967074774118131665\n', '        );\n', '        TOKEN.transfer(\n', '            0xAC465fF0D29d973A8D2Bae73DCF6404dD05Ae2c9,\n', '            39580596443330154509\n', '        );\n', '        TOKEN.transfer(\n', '            0xA4c8d9e4Ec5f2831701A81389465498B83f9457d,\n', '            975296945570158970585\n', '        );\n', '        TOKEN.transfer(\n', '            0x1d5E65a087eBc3d03a294412E46CE5D6882969f4,\n', '            61569818412187784720\n', '        );\n', '        TOKEN.transfer(\n', '            0xB17D5DB0EC93331271Ed2f3fFfEBE4E5b790D97E,\n', '            58637922335180229402\n', '        );\n', '        TOKEN.transfer(\n', '            0x579C5CE071691aec2EBfe45737D487860eB6F3f5,\n', '            138432234875160517780\n', '        );\n', '        TOKEN.transfer(\n', '            0xB8bDffa3De9939CeD80769B0B9419746a49F7Aa5,\n', '            577975365820343344830\n', '        );\n', '        TOKEN.transfer(\n', '            0xD2A78Bb82389D30075144d17E782964918999F7f,\n', '            586379252370365285114\n', '        );\n', '        TOKEN.transfer(\n', '            0x428700E86c104f4EE8139A69ecDCA09E843F6297,\n', '            41046544680591212929\n', '        );\n', '        TOKEN.transfer(\n', '            0x25125E438b7Ae0f9AE8511D83aBB0F4574217C7a,\n', '            267345029906476388503\n', '        );\n', '        TOKEN.transfer(\n', '            0x9832DBBAEB7Cc127c4712E4A0Bca286f10797A6f,\n', '            78375537718674422040\n', '        );\n', '        TOKEN.transfer(\n', '            0x20EADfcaf91BD98674FF8fc341D148E1731576A4,\n', '            107374139749379305392\n', '        );\n', '        TOKEN.transfer(\n', '            0xFe22a36fBfB8F797E5b39c061D522aDc8577C1F6,\n', '            5965227137222270504\n', '        );\n', '        TOKEN.transfer(\n', '            0xdADc6F71986643d9e9CB368f08Eb6F1333F6d8f9,\n', '            12489100784388025394\n', '        );\n', '        TOKEN.transfer(\n', '            0xEA72158A9749ca84C9ecBf10502846f7E4247642,\n', '            41756608047468442773\n', '        );\n', '        TOKEN.transfer(\n', '            0x07a1f6fc89223c5ebD4e4ddaE89Ac97629856A0f,\n', '            2982611978552889165\n', '        );\n', '        TOKEN.transfer(\n', '            0x48e68c7Fbeded45C16679E17cDb0454798D5e9B5,\n', '            59830771394752809300\n', '        );\n', '        TOKEN.transfer(\n', '            0xe49B4633879937cA21C004db7619F1548085fFFc,\n', '            39953886268715379214\n', '        );\n', '        TOKEN.transfer(\n', '            0xa57033C944106A32658321ec4248Ae3571521E9e,\n', '            3968531171669899089\n', '        );\n', '        TOKEN.transfer(\n', '            0x1e6E40A0432e7c389C1FF409227ccC9157A98C1b,\n', '            9928762147125684940\n', '        );\n', '        TOKEN.transfer(\n', '            0xC805A187EC680B73836265bdf62cdFB8bBb93413,\n', '            59726424533558073675\n', '        );\n', '        TOKEN.transfer(\n', '            0x4D608fB6d4Dd6b70023432274a37E4F1D3a8f62b,\n', '            3007894898452068880\n', '        );\n', '        TOKEN.transfer(\n', '            0xC45d45b54045074Ed12d1Fe127f714f8aCE46f8c,\n', '            33086874491593994867\n', '        );\n', '        TOKEN.transfer(\n', '            0x798F73c7Df3932F5c429e618C03828627E51eD63,\n', '            3007894898452068880\n', '        );\n', '        TOKEN.transfer(\n', '            0xdcEf782E211A100c928261B56d6e96Dc70F0c039,\n', '            3009132957553928009\n', '        );\n', '        TOKEN.transfer(\n', '            0x3942Ae3782FbD658CC19A8Db602D937baF7CB57A,\n', '            15045677508235608743\n', '        );\n', '        TOKEN.transfer(\n', '            0x3006f3eE31852aBE48A05621fCE90B9470ad71Fe,\n', '            3009132957553928009\n', '        );\n', '        TOKEN.transfer(\n', '            0x744b130afb4E0DFb99868B7A64a1F934b69004C4,\n', '            45137038487425249060\n', '        );\n', '        TOKEN.transfer(\n', '            0x0990fD97223D006eAE1f655e82467fA0eC5f0890,\n', '            42127902349754828877\n', '        );\n', '        TOKEN.transfer(\n', '            0x72Cf44B00B51AA96b5ba398ba38F65Cf7eFfDD05,\n', '            608313861593461456089\n', '        );\n', '        TOKEN.transfer(\n', '            0xFaFe7A735B6B27AEa570F2AebB65d2c022970D65,\n', '            1094609978642853353\n', '        );\n', '        TOKEN.transfer(\n', '            0xF9107317B0fF77eD5b7ADea15e50514A3564002B,\n', '            3009132957553928009\n', '        );\n', '        TOKEN.transfer(\n', '            0x96b0425C29ab7664D80c4754B681f5907172EC7C,\n', '            135411121623751450769\n', '        );\n', '        TOKEN.transfer(\n', '            0xbC904354748f3EAEa50F0eA36c959313FF55CC39,\n', '            99902579479290028361\n', '        );\n', '        TOKEN.transfer(\n', '            0xad3297e8dAA93b627ff599E9B8d43BfD170a6326,\n', '            42407303807126101170\n', '        );\n', '        TOKEN.transfer(\n', '            0xBE9630C2d7Bd2A54D65Ac4b4dAbB0241FfEB8DD6,\n', '            45436397163357714979\n', '        );\n', '        TOKEN.transfer(\n', '            0x663D29e6A43c67B4480a0BE9a7f71fC064E9cE37,\n', '            531417581668991346897\n', '        );\n', '        TOKEN.transfer(\n', '            0x966Cf5cd0624f1EfCf21B0abc231A5CcC802B861,\n', '            250374560089896160594\n', '        );\n', '        TOKEN.transfer(\n', '            0xCaea48e5AbC8fF83A781B3122A54d28798250C32,\n', '            56334273575512082775\n', '        );\n', '        TOKEN.transfer(\n', '            0x79D64144F05b18534E45B069C5c867089E13A4C6,\n', '            114167498354073162648\n', '        );\n', '        TOKEN.transfer(\n', '            0xD7925984736824B4Aecf8301c9aEE211Cd976494,\n', '            621704472724489775647\n', '        );\n', '        TOKEN.transfer(\n', '            0x1C051112075FeAEe33BCDBe0984C2BB0DB53CF47,\n', '            752460185045252127537\n', '        );\n', '        TOKEN.transfer(\n', '            0x2bc2CA2A7B3E6EdEF35223a211aC3B0b9b8d4346,\n', '            53655554125223094522\n', '        );\n', '        TOKEN.transfer(\n', '            0xA077bd3f8CdF7181f2beae0F1fFb71d27285034f,\n', '            41679739662920600636\n', '        );\n', '        TOKEN.transfer(\n', '            0xAABd5fBcb8ad62D4FbBB02a2E9769a9F2EE7e883,\n', '            6267630377181430617\n', '        );\n', '        TOKEN.transfer(\n', '            0x4565Ee03a020dAA77c5EfB25F6DD32e28d653c27,\n', '            5600124720503426131\n', '        );\n', '        TOKEN.transfer(\n', '            0xf0F8D1d90abb4Bb6b016A27545Ff088A4160C236,\n', '            3133812008474223135\n', '        );\n', '        TOKEN.transfer(\n', '            0x576B1C2d113C634d5849181442aEc5a3A9148c1e,\n', '            41493683568672242203\n', '        );\n', '        TOKEN.transfer(\n', '            0xB3f21996B59Ff2f1cD0fabbDf9Bc756e8F93FeC9,\n', '            42276583329899800253\n', '        );\n', '        TOKEN.transfer(\n', '            0x7777a6FE3687Ca7DA04573Eb185C09120D0e2690,\n', '            41650263560669209965\n', '        );\n', '        TOKEN.transfer(\n', '            0xb15e535dFFdf3fe70290AB89AecC3F18C7078CDc,\n', '            790547158521156473829\n', '        );\n', '        TOKEN.transfer(\n', '            0xca29358a0BBF2F1D6ae0911C3bC839623A3eE4a7,\n', '            46928308467932716630\n', '        );\n', '        TOKEN.transfer(\n', '            0xa289364347bfC1912ab672425Abe593ec01Ca56E,\n', '            6257104986621460796\n', '        );\n', '        TOKEN.transfer(\n', '            0xE26EDCA05417A65819295c49fC67272Ab247D791,\n', '            282193465688993016121\n', '        );\n', '        TOKEN.transfer(\n', '            0x29Bf88E2abD51E2f3958D380eD8e8f9aaDD33dA7,\n', '            2803580857024227800\n', '        );\n', '        TOKEN.transfer(\n', '            0xfDf7F859807d1dC73873640759b2706822802529,\n', '            8172716925701053147\n', '        );\n', '        TOKEN.transfer(\n', '            0xb653Bcf288eE8131Be0D0DDA79D03BfCFf9C3ae4,\n', '            250656280604668200604\n', '        );\n', '        TOKEN.transfer(\n', '            0xFf5dCd67b90b51eDDb8B2Cb4Fc7689e48Ac903A2,\n', '            36047895426460453298\n', '        );\n', '        TOKEN.transfer(\n', '            0x6cA94Fb85CFe9bea756BBb251fE1c80230b4B351,\n', '            45446644691239181178\n', '        );\n', '        TOKEN.transfer(\n', '            0x92EDED60a51898e04882ce88dbbC2674E531DEE4,\n', '            3895423672388613129\n', '        );\n', '        TOKEN.transfer(\n', '            0xb0e83C2D71A991017e0116d58c5765Abc57384af,\n', '            155321623279888651075\n', '        );\n', '        TOKEN.transfer(\n', '            0xffeDCDAC8BA51be3101607fAb1B44462c3015fb0,\n', '            3247507732059675518\n', '        );\n', '        TOKEN.transfer(\n', '            0xfF3fc772434505ABff38EEcDe3C689D4b0254528,\n', '            43191894595298372251\n', '        );\n', '        TOKEN.transfer(\n', '            0x9ef0E7A0d3404267f12E6511f5b70FCA263AB62E,\n', '            43841396817485061940\n', '        );\n', '        TOKEN.transfer(\n', '            0x84F87dc95e563cb472A1fBC6cDec58E9b74aC882,\n', '            313169135281887736166\n', '        );\n', '        TOKEN.transfer(\n', '            0x0154d25120Ed20A516fE43991702e7463c5A6F6e,\n', '            129900441654736007465\n', '        );\n', '        TOKEN.transfer(\n', '            0x8E97bA7e109Ba9063A09dcB9130e2f318ec0Da4e,\n', '            3881055309805132913\n', '        );\n', '        TOKEN.transfer(\n', '            0xDE41C393761772965Aa3b8618e9CD21A2b92ACD6,\n', '            3234502446907652985\n', '        );\n', '        TOKEN.transfer(\n', '            0x6ec93658A189C826A40664fbB4a542763c0a4BbB,\n', '            3234502446907652985\n', '        );\n', '        TOKEN.transfer(\n', '            0x888592eab1bC578279c5f2e44e32a9FEFDB83799,\n', '            8150951214642216848\n', '        );\n', '        TOKEN.transfer(\n', '            0xC05cFB4fa62BB3C9dF7Ac65fE77d28345aFa3485,\n', '            41119343311058196580\n', '        );\n', '        TOKEN.transfer(\n', '            0x1e44E34C1E07Ae17EB90fFDDB219db5E55B2776f,\n', '            9638149189061256487\n', '        );\n', '        TOKEN.transfer(\n', '            0x13928b49fe00db94392c5886D9BC878450399d07,\n', '            14392016687463560481\n', '        );\n', '        TOKEN.transfer(\n', '            0x3fDDDE5ed6f20CB9E2a8215D5E851744D9c93d17,\n', '            11244507917257547930\n', '        );\n', '        TOKEN.transfer(\n', '            0xA3f76c31f57dA65B0ce84c64c25E61BF38c86BEd,\n', '            10245352880542832924\n', '        );\n', '        TOKEN.transfer(\n', '            0xFB865683277e54658DaB0FA90E049616cb7f254C,\n', '            5434775641909755476\n', '        );\n', '        TOKEN.transfer(\n', '            0x718FdF375E1930Ba386852E35F5bAFC31df3AE66,\n', '            306819492775258231992\n', '        );\n', '        TOKEN.transfer(\n', '            0x07295d129f841f2854f9f298F137C2fFc5CCfF34,\n', '            94784075451234983347\n', '        );\n', '        TOKEN.transfer(\n', '            0x1Ec2C4e7Fff656f76c5A4992bd5efA7e7fF1A460,\n', '            64059195316591034432\n', '        );\n', '        TOKEN.transfer(\n', '            0xB71CD2a879c8D887eA8d75155ff51116178641C0,\n', '            147639880961783144609\n', '        );\n', '        TOKEN.transfer(\n', '            0x2f05c805d62c9B4D498d1f3E4fE42c612f0BE6B8,\n', '            3209559401958574266\n', '        );\n', '        TOKEN.transfer(\n', '            0x30a73afACB7735e1861Ca7d7C697cD0b66f1b95A,\n', '            233429909807097132046\n', '        );\n', '        TOKEN.transfer(\n', '            0x487d0c7553c8d88500085A805d316eD5b18357f8,\n', '            2094523226404826032\n', '        );\n', '        TOKEN.transfer(\n', '            0x16f037a3dDf53dA1b047A926E1833219F0a8E1FC,\n', '            376787718595509223557\n', '        );\n', '        TOKEN.transfer(\n', '            0x4523b791292da89A9194B61bA4CD9d98f2af68E0,\n', '            3993450879578078165\n', '        );\n', '        TOKEN.transfer(\n', '            0x5bd75fF024e79c5d94D36884622A65E6747E3D4F,\n', '            24754395675530675337\n', '        );\n', '        TOKEN.transfer(\n', '            0x71F12a5b0E60d2Ff8A87FD34E7dcff3c10c914b0,\n', '            386398274012119735672\n', '        );\n', '        TOKEN.transfer(\n', '            0x806388E04b7583a0148451A8ECd29A748b8fd584,\n', '            32224020738759322411\n', '        );\n', '        TOKEN.transfer(\n', '            0x1014440506b3384976F70f5dcbfC76f7C3cb53D6,\n', '            2478768528549672333\n', '        );\n', '        TOKEN.transfer(\n', '            0xE7B80338fE1645AF7e6e1D160F538E04241b9288,\n', '            47096646918161693674\n', '        );\n', '        TOKEN.transfer(\n', '            0x674BE6fA9CE93405e824bbD2fA6Afe27290ba3AA,\n', '            139877542203501354655\n', '        );\n', '        TOKEN.transfer(\n', '            0xCdE771CB4b774D9e78192D111Ab45A34CF60e583,\n', '            235036043752484801015\n', '        );\n', '        TOKEN.transfer(\n', '            0x1378e334f767F334fBe10330fA54adc2a001a8BD,\n', '            32077405321596096473\n', '        );\n', '        TOKEN.transfer(\n', '            0x9fd31424CfcEAb50218906BC1b3d87fe7778CA61,\n', '            4421538213178997602\n', '        );\n', '        TOKEN.transfer(\n', '            0x7bdfE11c4981Dd4c33E1aa62457B8773253791b3,\n', '            56289996441764296682\n', '        );\n', '        TOKEN.transfer(\n', '            0xef764BAC8a438E7E498c2E5fcCf0f174c3E3F8dB,\n', '            565130541313621871521\n', '        );\n', '        TOKEN.transfer(\n', '            0xdf3910d26836318379903A47bD26d0E05Cc9a0f5,\n', '            2443580021897230476\n', '        );\n', '        TOKEN.transfer(\n', '            0xcA9f486512154391C63A67069BFc1b1E4FB44774,\n', '            419167154022971898491\n', '        );\n', '        TOKEN.transfer(\n', '            0xf56036f6a5D9b9991c209DcbC9C40b2C1cD46540,\n', '            34177667435560753739\n', '        );\n', '        TOKEN.transfer(\n', '            0x1507E4137957B3C69c0cFBD86F02b7889C78e364,\n', '            1678732345492730959\n', '        );\n', '\n', '        selfdestruct(address(0x0));\n', '    }\n', '}']