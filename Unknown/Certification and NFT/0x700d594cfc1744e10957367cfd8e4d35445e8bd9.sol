['pragma solidity ^0.4.14;\n', '\n', 'contract CicadaToken {\n', '    /* Public variables of the Cicada token. Not made by the "official" Cicada 3301... or is it? \n', '        No, probably not, you&#39;re paranoid. Or am I? What if we&#39;re all Cicada? \n', '        No, you&#39;re delusional.\n', '        This is insanity, or maybe it&#39;s genius?\n', '        \n', '        We barely could wait this moment...\n', '        \n', '        2+5+1=8\n', '        25*13=325\n', '        15,31,3301\n', '        sqrt(324)=18\n', '        360360/7=51480\n', '        360360/8=45045\n', '        2513/800=3.14125\n', '        0.2:17.1-2:48.1:3.0:\n', '        \n', '        2.192049988θ 5.58268339λ 9.7977693090G\n', '        2.247000175θ 2.981716939λ 9.800514797G\n', '        1.158788615θ 2.32884262λ 9.7862954650G\n', '        2.543813754θ 3.798403597λ 9.815386451G\n', '        0.9800521274θ 5.781580817λ 9.79624214G\n', '        \n', '        1089287209,1731065632,1293893558,2643986998,2760389337, 2760389337,3568826184,3178676277,2183895820,2543659070, 2543659070,2919791668,1361677804,3926934151,1617304876, 1617304876,1623817017,1840265213,3059753916,3495850100, 3495850100,2779122780,3703974151,1504463065,371931331, 371931331,2194531146,591366817,1289280794,1454640230, 1454640230,3751306772,286836652,82106479,1353632321, 1353632321,1978935931,129784666,2165612938,302519271, 302519271,667805565,2104503549,1748047881,3143345858, 3143345858,2567161908,844070088,3531551908,2467396602, 2467396602,1990243106,2313045040,1552967400,1873430530, 1873430530,3016683839,960906741,1721405341,3031535805, 3031535805,1955189866,3308308023,3408057436,1053761308, 1053761308,3325869169,293492001,3050005651,1449160016,3019723895, 1449160016,3019723895,631258258,1117748972,1360032086,4202359100, 1360032086,4202359100,1377521687,2916041631,3594610343,1283949744, 3594610343,1283949744,2813523239,834212454,1259726505,1418243105, 1259726505,1418243105,2398810229,3405631455,583373212,121296986, 583373212,121296986,889286024,2884948373,1074344036,2259419743, 1074344036,2259419743,3277259298,1174437393,2795777571,1562207636, 2795777571,1562207636,2171732791,2956478056,3787583060,1407756383, 3787583060,1407756383,1642154795,2704472112,2767934171,424994609, 2767934171,424994609,2202848543,736480564,3045833213,3005171440, 3045833213,3005171440,405401169,1469264431,1221013806,1778305550, 1221013806,1778305550,4149771067,2979449995,4288475081,483827587, 4288475081,483827587,1367887139,522769879,2923195508,154691999, 2923195508,154691999,1923517015,1216850072,162547509,1729425590, 162547509,1729425590,340416303,2759327460,\n', '        We ask this because We care about you\n', '        \n', '        clues4u\n', '        \n', '        Watch the website closely on August 21st, September 23rd, Novermber 11th and December 21st 2017 \n', '        .site/date should get you the tokens you look for if you&#39;re faster than the others on those dates.\n', '       \n', '        Once upon a time, I, Chuang Chou, dreamt I was a butterfly, \n', '        fluttering hither and thither, to all intents and purposes a butterfly. \n', '        I was conscious only of my happiness as a butterfly, unaware that I was Chou. \n', '        Soon I awaked, and there I was, veritably myself again. \n', '        Now I do not know whether I was then a man dreaming I was a butterfly, \n', '        or whether I am now a butterfly, dreaming I am a man. \n', '        Between a man and a butterfly there is necessarily a distinction. \n', '        The transition is called the transformation of material things.*/\n', '    string public standard = &#39;Cicada 33.01&#39;;\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals;\n', '    uint256 public initialSupply;\n', '\n', '    /* This creates an array with all balances */\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '\n', '  \n', '    /* Initializes contract with initial supply tokens to the creator of the contract\n', '        Restate my assumptions: One, Mathematics is the language of nature. \n', '        Two, Everything around us can be represented and understood through numbers. \n', '        Three: If you graph the numbers of any system, patterns emerge. \n', '        Therefore, there are patterns everywhere in nature. \n', '        Evidence: The cycling of disease epidemics;the wax and wane of caribou populations; \n', '        sun spot cycles; the rise and fall of the Nile. \n', '        So, what about the crypto market? \n', '        The universe of numbers that represents the global economy. \n', '        Millions of hands at work, billions of minds. \n', '        A vast network, screaming with life. An organism.\n', '        A natural organism. \n', '        My hypothesis: Within the crypto market, there is a pattern as well... \n', '        Right in front of me... hiding behind the numbers. Always has been.*/\n', '        \n', '    function CicadaToken() {\n', '\n', '         initialSupply = 3301000000000;\n', '         name ="CICADA";\n', '         decimals = 9;\n', '         symbol = "3301";\n', '        \n', '        balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens\n', '        uint256 totalSupply = initialSupply;                // Update total supply\n', '                                   \n', '    }\n', '\n', '    /* Send coins \n', '    The Ancient Japanese considered the Go board to be a microcosm of the universe. \n', '    Although when it is empty it appears to be simple and ordered, \n', '    in fact, the possibilities of gameplay are endless. \n', '    They say that no two Go games have ever been alike. Just like snowflakes. \n', '    So, the Go board actually represents an extremely complex and chaotic universe.*/\n', '    \n', '    function transfer(address _to, uint256 _value) {\n', '        if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough\n', '        if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows\n', '        balanceOf[msg.sender] -= _value;                     // Subtract from the sender\n', '        balanceOf[_to] += _value;                            // Add the same to the recipient\n', '      \n', '    }\n', '    \n', '    function mul(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '    }  \n', '}']
['pragma solidity ^0.4.14;\n', '\n', 'contract CicadaToken {\n', '    /* Public variables of the Cicada token. Not made by the "official" Cicada 3301... or is it? \n', "        No, probably not, you're paranoid. Or am I? What if we're all Cicada? \n", "        No, you're delusional.\n", "        This is insanity, or maybe it's genius?\n", '        \n', '        We barely could wait this moment...\n', '        \n', '        2+5+1=8\n', '        25*13=325\n', '        15,31,3301\n', '        sqrt(324)=18\n', '        360360/7=51480\n', '        360360/8=45045\n', '        2513/800=3.14125\n', '        0.2:17.1-2:48.1:3.0:\n', '        \n', '        2.192049988θ 5.58268339λ 9.7977693090G\n', '        2.247000175θ 2.981716939λ 9.800514797G\n', '        1.158788615θ 2.32884262λ 9.7862954650G\n', '        2.543813754θ 3.798403597λ 9.815386451G\n', '        0.9800521274θ 5.781580817λ 9.79624214G\n', '        \n', '        1089287209,1731065632,1293893558,2643986998,2760389337, 2760389337,3568826184,3178676277,2183895820,2543659070, 2543659070,2919791668,1361677804,3926934151,1617304876, 1617304876,1623817017,1840265213,3059753916,3495850100, 3495850100,2779122780,3703974151,1504463065,371931331, 371931331,2194531146,591366817,1289280794,1454640230, 1454640230,3751306772,286836652,82106479,1353632321, 1353632321,1978935931,129784666,2165612938,302519271, 302519271,667805565,2104503549,1748047881,3143345858, 3143345858,2567161908,844070088,3531551908,2467396602, 2467396602,1990243106,2313045040,1552967400,1873430530, 1873430530,3016683839,960906741,1721405341,3031535805, 3031535805,1955189866,3308308023,3408057436,1053761308, 1053761308,3325869169,293492001,3050005651,1449160016,3019723895, 1449160016,3019723895,631258258,1117748972,1360032086,4202359100, 1360032086,4202359100,1377521687,2916041631,3594610343,1283949744, 3594610343,1283949744,2813523239,834212454,1259726505,1418243105, 1259726505,1418243105,2398810229,3405631455,583373212,121296986, 583373212,121296986,889286024,2884948373,1074344036,2259419743, 1074344036,2259419743,3277259298,1174437393,2795777571,1562207636, 2795777571,1562207636,2171732791,2956478056,3787583060,1407756383, 3787583060,1407756383,1642154795,2704472112,2767934171,424994609, 2767934171,424994609,2202848543,736480564,3045833213,3005171440, 3045833213,3005171440,405401169,1469264431,1221013806,1778305550, 1221013806,1778305550,4149771067,2979449995,4288475081,483827587, 4288475081,483827587,1367887139,522769879,2923195508,154691999, 2923195508,154691999,1923517015,1216850072,162547509,1729425590, 162547509,1729425590,340416303,2759327460,\n', '        We ask this because We care about you\n', '        \n', '        clues4u\n', '        \n', '        Watch the website closely on August 21st, September 23rd, Novermber 11th and December 21st 2017 \n', "        .site/date should get you the tokens you look for if you're faster than the others on those dates.\n", '       \n', '        Once upon a time, I, Chuang Chou, dreamt I was a butterfly, \n', '        fluttering hither and thither, to all intents and purposes a butterfly. \n', '        I was conscious only of my happiness as a butterfly, unaware that I was Chou. \n', '        Soon I awaked, and there I was, veritably myself again. \n', '        Now I do not know whether I was then a man dreaming I was a butterfly, \n', '        or whether I am now a butterfly, dreaming I am a man. \n', '        Between a man and a butterfly there is necessarily a distinction. \n', '        The transition is called the transformation of material things.*/\n', "    string public standard = 'Cicada 33.01';\n", '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals;\n', '    uint256 public initialSupply;\n', '\n', '    /* This creates an array with all balances */\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '\n', '  \n', '    /* Initializes contract with initial supply tokens to the creator of the contract\n', '        Restate my assumptions: One, Mathematics is the language of nature. \n', '        Two, Everything around us can be represented and understood through numbers. \n', '        Three: If you graph the numbers of any system, patterns emerge. \n', '        Therefore, there are patterns everywhere in nature. \n', '        Evidence: The cycling of disease epidemics;the wax and wane of caribou populations; \n', '        sun spot cycles; the rise and fall of the Nile. \n', '        So, what about the crypto market? \n', '        The universe of numbers that represents the global economy. \n', '        Millions of hands at work, billions of minds. \n', '        A vast network, screaming with life. An organism.\n', '        A natural organism. \n', '        My hypothesis: Within the crypto market, there is a pattern as well... \n', '        Right in front of me... hiding behind the numbers. Always has been.*/\n', '        \n', '    function CicadaToken() {\n', '\n', '         initialSupply = 3301000000000;\n', '         name ="CICADA";\n', '         decimals = 9;\n', '         symbol = "3301";\n', '        \n', '        balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens\n', '        uint256 totalSupply = initialSupply;                // Update total supply\n', '                                   \n', '    }\n', '\n', '    /* Send coins \n', '    The Ancient Japanese considered the Go board to be a microcosm of the universe. \n', '    Although when it is empty it appears to be simple and ordered, \n', '    in fact, the possibilities of gameplay are endless. \n', '    They say that no two Go games have ever been alike. Just like snowflakes. \n', '    So, the Go board actually represents an extremely complex and chaotic universe.*/\n', '    \n', '    function transfer(address _to, uint256 _value) {\n', '        if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough\n', '        if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows\n', '        balanceOf[msg.sender] -= _value;                     // Subtract from the sender\n', '        balanceOf[_to] += _value;                            // Add the same to the recipient\n', '      \n', '    }\n', '    \n', '    function mul(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '    }  \n', '}']
