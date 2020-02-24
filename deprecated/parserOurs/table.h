#ifndef TABLE_H
#define TABLE_H

#include <stdlib.h>
#include <stdio.h>
#include <stdint.h>
#include <limits.h>
#include <string.h>

#define TABLE_SIZE 200

struct node_s {
    char *lexeme;
    int token;
    char *type;
    struct node_s *next;
};

typedef struct node_s node_t;

struct table_s {
    node_t **hashtable;
    int size;
};

typedef struct table_s table_t;


table_t* create_table () {

    int size = TABLE_SIZE;
    table_t *table = (table_t*) malloc(sizeof(table_t));

    if(table) {
        table->hashtable = (node_t**) malloc(sizeof(node_t*) * size);
        if(table->hashtable) {
            table->size = size;
            for (int i = 0; i < table->size; i++) {
                table->hashtable[i] = NULL;
            }
        }
    }
    return table;
}

node_t* create_node(char* lexeme, int token, char* type) {
    node_t* node = (node_t*) malloc(sizeof(node_t));

    if(node) {
        node->lexeme = strdup(lexeme);
        // node->lexeme = "Abc";
        node->type = strdup(type);
        if(!node->lexeme) return NULL;
        if(!node->type) return NULL;


        node->token = token;
        node->next = NULL;
    }

    return node;
}

uint32_t hash( char *lexeme )
{
    size_t i;
    uint32_t hash;
    for ( hash = i = 0; i < strlen(lexeme); ++i ) {
        hash += lexeme[i];
        hash += ( hash << 10 );
        hash ^= ( hash >> 6 );
    }
    hash += ( hash << 3 );
    hash ^= ( hash >> 11 );
    hash += ( hash << 15 );

    return hash % TABLE_SIZE;
}

node_t* find(table_t* table, char* lexeme)
{
	uint32_t idx = 0;
	node_t* iterator;

    idx = hash(lexeme);
	iterator = table->hashtable[idx];

	while(iterator != NULL && strcmp( lexeme, iterator->lexeme ) != 0)
	{
		iterator = iterator->next;
	}

	if(iterator == NULL) return NULL;
	else return iterator;
}


void insert(table_t *table, char* lexeme, int token, char* type) {

    if(find(table, lexeme)) {
        return;
    }

    uint32_t idx;

	idx = hash(lexeme);
    node_t* entry = create_node(lexeme, token, type);
    node_t* head = NULL;

	if(!entry)
	{
		printf("Error: Hash table insert failed.");
		exit(1);
	}

    head = table->hashtable[idx];

	if(head == NULL)
	{
		table->hashtable[idx] = entry;
	}
	else
	{
		entry->next = table->hashtable[idx];
        table->hashtable[idx] = entry;
	}
}

void display_table(table_t* table) {
    int i;
    node_t* iterator;
    printf("\n----------------------------------------------\n");
    printf("| %-20s | %6s | %-10s |\n", "Lexeme", "Token", "Datatype");
    printf(  "----------------------------------------------\n");

    for(i = 0; i < table->size; i++)
    {
        iterator = table->hashtable[i];

        while( iterator != NULL)
        {
            printf("| %-20s | %6d | %-10s |\n", iterator->lexeme, iterator->token, iterator->type);
            iterator = iterator->next;
        }
    }
    printf("----------------------------------------------\n");
}

void display(table_t* table, char* name) {
    printf("\n----------------------------------------------\n");
    printf("| %-42s |", name);
    display_table(table);
}

#endif