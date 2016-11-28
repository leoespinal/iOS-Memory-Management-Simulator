//
//  CPU.swift
//  MemoryManagementSimulator
//
//  Created by Rosemary Espinal on 11/27/16.
//  Copyright © 2016 Espinal Designs, LLC. All rights reserved.
//

import Foundation

class CPU {
    let processTimeSlice: UInt32 = 30 //30 second time slice for process execution
    
    func executeProcesses(queue: ProcessQueue) {
        if (queue.isEmpty()) {
            print("The queue to empty. Waiting for more processes to arrive...")
        }
        //Let each process run for 30 seconds only then remove it from queue
        for _ in 0...queue.size() {
            sleep(processTimeSlice)
            queue.removeFromQueue()
        }
    }
    
    //Process address space needs to be generated by the CPU (page number + offset)
    func generateVirtualAddress(process: Process) -> Int {
        let virtualAddressSpace = process.createVirtualAddressSpace()
        let pageAccessed = process.randomizePageAccess(process: process)
        let pageVirtualAddress = process.createPageVirtualAddress(pageNumber: pageAccessed)
        return pageVirtualAddress
    }
    
    //Handles page faults
    func handlePageFault(process: Process, processPageTable: HashedPageTable, memory: PhysicalMemory) {
        let freeFrames = memory.getFreeFrameList()
        for index in freeFrames {
            if (freeFrames[index] == -1) {
                //this is a free frame that can be used for the page
                var mmu = MMU()
                var pageNumber = mmu.splitVirtualAddress(process: process)
                
                //update the page table with the new frame for the process page
                processPageTable.updatePageTable(processVirtualPageNumber: pageNumber, processMappedFrame: freeFrames[index])
            }
        }
    }
}
