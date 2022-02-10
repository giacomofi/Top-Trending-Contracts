['pragma solidity ^0.4.0;\n', '\n', '\n', '\n', 'contract Owned {\n', '    address owner;\n', '\n', '    modifier onlyOwner() {\n', '        if (msg.sender == owner) {\n', '            _;\n', '        }\n', '    }\n', '\n', '    function Owned() {\n', '        owner = msg.sender;\n', '    }\n', '}\n', '\n', 'contract Mortal is Owned {\n', '\n', '    function kill() onlyOwner {\n', '        if (msg.sender == owner) {\n', '            selfdestruct(owner);\n', '        }\n', '    }\n', '\n', '}\n', '\n', 'contract CVExtender {\n', '\n', '    function getDescription() constant returns (string);\n', '    function getTitle() constant returns (string);\n', '    function getAuthor() constant returns (string, string);\n', '    function getAddress() constant returns (string);\n', '\n', '    function elementsAreSet() constant returns (bool) {\n', '        //Normally I&#39;d do whitelisting, but for sake of simplicity, lets do blacklisting\n', '\n', '        bytes memory tempEmptyStringTest = bytes(getDescription());\n', '        if(tempEmptyStringTest.length == 0) {\n', '            return false;\n', '        }\n', '        tempEmptyStringTest = bytes(getTitle());\n', '        if(tempEmptyStringTest.length == 0) {\n', '            return false;\n', '        }\n', '        var (testString1, testString2) = getAuthor();\n', '\n', '        tempEmptyStringTest = bytes(testString1);\n', '        if(tempEmptyStringTest.length == 0) {\n', '            return false;\n', '        }\n', '        tempEmptyStringTest = bytes(testString2);\n', '        if(tempEmptyStringTest.length == 0) {\n', '            return false;\n', '        }\n', '        tempEmptyStringTest = bytes(getAddress());\n', '        if(tempEmptyStringTest.length == 0) {\n', '            return false;\n', '        }\n', '        return true;\n', '    }\n', '}\n', '\n', '\n', 'contract CVAlejandro is Mortal, CVExtender {\n', '\n', '    string[] _experience;\n', '    string[] _education;\n', '    string[] _language;\n', '\n', '    string _name;\n', '    string _summary;\n', '    string _email;\n', '    string _link;\n', '    string _description;\n', '    string _title;\n', '\n', '    // Social\n', '    string _linkedIn;\n', '    string _twitter;\n', '    string _gitHub;\n', '\n', '\n', '\n', '    function CVAlejandro() {\n', '\n', '        // Main\n', '        _name = "Alejandro Saucedo";\n', '        _email = "<a href="/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="5c3d1c397124723533">[email&#160;protected]</a>";\n', '        _link = "https://github.com/axsauze/ethereum-solidity-cv-contract";\n', '        _description = "CTO. Manager. Engineer.";\n', '        _title = "Alejandro ETH CV";\n', '        _summary = "My experience ranges from chief technology officer, to engineering manager, to hands on software/devops engineer at startups and tech giants. I have designed and led the development of multiple software projects, and I have coordinated multiple national and global initiatives. I have deep technical knowledge, as well as managerial, leadership and people skills. I am highly driven by impact, and I strongly abide by my values.";\n', '\n', '        // Social\n', '        _linkedIn = "http://linkedin.com/in/axsaucedo";\n', '        _gitHub = "https://github.com/axsauze";\n', '        _twitter = "https://twitter.com/axsaucedo";\n', '\n', '        // Experience\n', '        _experience.push("J.P. Morgan, Java Engineer");\n', '        _experience.push("CTVE Shanghai China, English Teacher & Coordinator");\n', '        _experience.push("Bloomberg LP, Software Engineer Intern");\n', '        _experience.push("WakeUpRoulette, Founder & Chief Technology Officer");\n', '        _experience.push("GitHack, Founder & Open Source Lead Engineer");\n', '        _experience.push("Founders4Schools, Advisor");\n', '        _experience.push("Techstars, Global Facilitator");\n', '        _experience.push("HackaGlobal, Founder & Managing Director");\n', '        _experience.push("Bloomberg LP, Full Stack Software Engineer");\n', '        _experience.push("Hack Partners, Co-founder & Chief Technology Officer");\n', '        _experience.push("Entrepreneur First, Entrepreneur in Residence");\n', '        _experience.push("Exponential Technologies, Founder & Chief Engineer");\n', '\n', '        // Education\n', '        _education.push("University of Southampton, BEng. Software Engineering (1st Class Honours)");\n', '\n', '        // Languages\n', '        _language.push("English");\n', '        _language.push("Spanish");\n', '        _language.push("Mandarin");\n', '        _language.push("Russian");\n', '        _language.push("Portuguese");\n', '    }\n', '\n', '    // UTIL\n', '\n', '    function popFromStringArray(string[] storage array) internal {\n', '        if(array.length < 1) return;\n', '\n', '        array.length--;\n', '    }\n', '\n', '    function strArrayConcat(string[] storage array) internal returns (string){\n', '\n', '        uint totalSize = 0;\n', '        uint i = 0;\n', '        uint j = 0;\n', '        uint strIndex = 0;\n', '        bytes memory currStr;\n', '\n', '        for(i = 0; i < array.length; i++) {\n', '            currStr = bytes(array[i]);\n', '            // We add the total plus the \\n character\n', '            totalSize = totalSize + currStr.length + 1;\n', '        }\n', '\n', '        string memory stringBuffer = new string(totalSize);\n', '        bytes memory bytesResult = bytes(stringBuffer);\n', '\n', '        for(i = 0; i < array.length; i++) {\n', '            currStr = bytes(array[i]);\n', '\n', '            for(j = 0; j < currStr.length; j++) {\n', '                bytesResult[strIndex] = currStr[j];\n', '                strIndex = strIndex + 1;\n', '            }\n', '\n', '            bytesResult[strIndex] = byte("\\n");\n', '            strIndex = strIndex + 1;\n', '        }\n', '\n', '        return string(bytesResult);\n', '    }\n', '\n', '\n', '    // MAIN\n', '\n', '    function getEmail() constant returns(string) {\n', '        return _email;\n', '    }\n', '\n', '    function setEmail(string email) onlyOwner {\n', '        _email = email;\n', '    }\n', '\n', '    function getName() constant returns(string) {\n', '        return _name;\n', '    }\n', '\n', '    function setName(string name) onlyOwner {\n', '        _name = name;\n', '    }\n', '\n', '    function getSummary() constant returns(string) {\n', '        return _summary;\n', '    }\n', '\n', '    function setSummary(string summary) onlyOwner {\n', '        _summary = summary;\n', '    }\n', '\n', '\n', '\n', '    // EXPERIENCE\n', '\n', '    function getExperience() constant returns(string) {\n', '        return strArrayConcat(_experience);\n', '    }\n', '\n', '    function addExperience(string experience) onlyOwner {\n', '        _experience.push(experience);\n', '    }\n', '\n', '    function popExperience() onlyOwner {\n', '        popFromStringArray(_experience);\n', '    }\n', '\n', '    function getEducation() constant returns(string) {\n', '        return strArrayConcat(_education);\n', '    }\n', '\n', '    function addEducation(string education) onlyOwner {\n', '        _education.push(education);\n', '    }\n', '\n', '    function popEducation() onlyOwner {\n', '        popFromStringArray(_education);\n', '    }\n', '\n', '    function getLanguage() constant returns(string) {\n', '        return strArrayConcat(_language);\n', '    }\n', '\n', '    function addLanguage(string language) onlyOwner {\n', '        _language.push(language);\n', '    }\n', '\n', '    function popLanguage() onlyOwner {\n', '        popFromStringArray(_language);\n', '    }\n', '\n', '    function getLinkedIn() constant returns(string) {\n', '        return _linkedIn;\n', '    }\n', '\n', '    function setLinkedIn(string linkedIn) onlyOwner {\n', '        _linkedIn = linkedIn;\n', '    }\n', '\n', '    function getGitHub() constant returns(string) {\n', '        return _gitHub;\n', '    }\n', '\n', '    function setGitHub(string gitHub) onlyOwner {\n', '        _gitHub = gitHub;\n', '    }\n', '\n', '    function getTwitter() constant returns(string) {\n', '        return _twitter;\n', '    }\n', '\n', '    function setTwitter(string twitter) onlyOwner {\n', '        _twitter = twitter;\n', '    }\n', '\n', '\n', '\n', '    // INHERITED from CVExtender\n', '\n', '    function getAddress() constant returns(string) {\n', '        return _link;\n', '    }\n', '\n', '    function setAddress(string link) onlyOwner {\n', '        _link = link;\n', '    }\n', '\n', '    function getDescription() constant returns(string) {\n', '        return _description;\n', '    }\n', '\n', '    function setDescription(string description) onlyOwner {\n', '        _description = description;\n', '    }\n', '\n', '    function getTitle() constant returns(string) {\n', '        return _title;\n', '    }\n', '\n', '    function setTitle(string title) onlyOwner {\n', '        _title = title;\n', '    }\n', '\n', '    function getAuthor() constant returns(string, string) {\n', '        return (_name, _email);\n', '    }\n', '\n', '}']