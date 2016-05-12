local task =  {
    task_root2 =  {
                   name = "task",
                   item =  {
                              [1] = {
                                    name = "item",
                                    },
                          },
                   },
    role =  {
             bag2 =  {
                      grid =  {
                               name = "grid",
                               },
                      },
             bag1 =  {
                        [1] = {
                              grid =  {
                                         [1] = {
                                               name = "grid",
                                               },
                                     },
                              },
                    },
             },
    task_root3 =  {
                   name = "task",
                   item =  {
                            [1] = {
                                  name = "item",
                                  },
                            [2] = {
                                  name = "item",
                                  },
                            },
                   },
    task_root =  {
                  name = "task",
                  item =  {
                           name = "item",
                           },
                  },
}

return task
