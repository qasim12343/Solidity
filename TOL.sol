// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract TOL {
    
    struct Person{
        uint16 pid;
        uint16 freindPid;
        uint16 tokens;
        bool tought;
    }
    uint16 pidSize;
    
    constructor() {
        pidSize = 0;
    }
    struct Time{
        uint16 hour;
        uint16 minute;
        uint16 second;
    }
    mapping (uint16 => Person) persons;
    function getTime()public view returns (Time memory){
        
        uint256 stime = uint256(block.timestamp) + uint256(210)*60;
        uint16 hour = uint16((stime / 3600) % 24);
        uint16 minute = uint16((stime / 60) % 60);
        uint16 second = uint16(stime % 60);
        return Time(hour, minute, second);
    }
    function getPerson(uint16 pid)public view returns(Person memory){
        return persons[pid];
    }
    function weAreFreinds(uint16 pid1, uint16 pid2) public{
        require(pid1 <= pidSize && pid2 <= pidSize,"Not Known");
        require(persons[pid1].freindPid == 0 && persons[pid2].freindPid == 0,"Are you non-monogamous");
        persons[pid1].freindPid = pid2;
        persons[pid2].freindPid = pid1;
    }
    function addPerson()public{
        pidSize ++;
        persons[pidSize].pid = pidSize;
        persons[pidSize].freindPid = 0;
        persons[pidSize].tokens = 0;
        persons[pidSize].tought = false;
    }
    

    function thoughtOfThem(uint16 pid) public{
        uint16 fid = persons[pid].freindPid;
        require(fid >0, "You are single my friend");
        //Time memory t = getTime();

        //require(t.hour == 11 && t.minute == 11,"Time is not 11:11");
        persons[pid].tought = true;
        if(persons[fid].tought == true){
            persons[pid].tokens += 100;
            persons[fid].tokens += 100;
            persons[pid].tought = false;
            persons[fid].tought = false;
        }

    }

    function weCut(uint16 pid) public{
        uint16 fid = persons[pid].freindPid;
        require(fid > 0, "You are not able to cut, you are single");
        persons[pid].freindPid = 0;
        persons[fid].freindPid = 0;
    }
    
}